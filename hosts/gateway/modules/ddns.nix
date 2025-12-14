{ vars, pkgs, ... }:

let
  cloudflareEmail = "neekokun@proton.me";
  cloudflareApiKey = "vdS4xVeRD7zkjSZoi3uIewi4wXKxKDXoQQ3b2Zd1";
  cloudflareZoneId = "59198c0b5ea5132371b7a801f7b89f8a";

  domains = [
    "neekokun.com"
    "grafana.neekokun.com"
  ];

  updateScript = pkgs.writeShellScript "cloudflare-ddns" ''
    set -e

    # Get current public IP
    IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)

    echo "Current IP: $IP"

    ${pkgs.lib.concatMapStringsSep "\n" (domain: ''
      echo "Updating ${domain}..."

      # Get DNS record ID
      RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/${cloudflareZoneId}/dns_records?name=${domain}" \
        -H "X-Auth-Email: ${cloudflareEmail}" \
        -H "X-Auth-Key: ${cloudflareApiKey}" \
        -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')

      if [ "$RECORD_ID" != "null" ]; then
        # Update existing record
        ${pkgs.curl}/bin/curl -s -X PUT \
          "https://api.cloudflare.com/client/v4/zones/${cloudflareZoneId}/dns_records/$RECORD_ID" \
          -H "X-Auth-Email: ${cloudflareEmail}" \
          -H "X-Auth-Key: ${cloudflareApiKey}" \
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
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare Dynamic DNS Update";

    after = [ "network.target" ];

    serviceConfig = {
      Type = "oneshot";
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
