# Copyright (C) 2026 NeekoKun
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

{ flakeRoot, config, vars, pkgs, ... }:

let
  cloudflareEmail = "neekokun@proton.me";
  
  domains = [
    "neekokun.com"
  ];

  updateScript = pkgs.writeShellScript "cloudflare-ddns" ''
    set -e

    # Get current public IP
    IP=$(${pkgs.curl}/bin/curl -s ifconfig.me)

    echo "Current IP: $IP"

    ${pkgs.lib.concatMapStringsSep "\n" (domain: ''
      echo "Updating ${domain}..."

      # Get DNS record ID
      RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?name=${domain}" \
        -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
        -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')

      if [ "$RECORD_ID" != "null" ]; then
        # Update existing record
        ${pkgs.curl}/bin/curl -s -X PUT \
          "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$RECORD_ID" \
          -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
          -H "Content-Type: application/json" \
          --data "{\"type\":\"A\",\"name\":\"${domain}\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":false}"

        echo "Updated ${domain} to $IP"
      else
        echo "Record not found for ${domain}"
      fi
    '') domains}
  '';
in
{
  age.secrets.cloudflareEnv.file = "${flakeRoot}/secrets/cloudflare-env.age";

  systemd.services.cloudflare-ddns = {
    description = "Cloudflare Dynamic DNS Update";

    after = [ "network.target" ];

    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.age.secrets.cloudflareEnv.path;
      ExecStart = "${updateScript}";
    };
  };

  systemd.timers.cloudflare-ddns = {
    description = "Update Cloudflare DDNS Every 5 Minutes";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
  };
}
