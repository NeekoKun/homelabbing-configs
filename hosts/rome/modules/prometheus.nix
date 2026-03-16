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

{ config, vars, ... }:

{
  services.prometheus = {
    enable = true;
    port = vars.services.prometheus.http_port;

    webExternalUrl = "http://0.0.0.0:${toString vars.services.prometheus.http_port}";
    listenAddress = "0.0.0.0";
    # Hack to inject manually max disk throughput values for each host 
    rules = [ #TODO: Add manual values for Babylon and Alexandria
      ''
        groups: 
          - name: disk_max_throughput
            rules:
              - record: host_disk_max_read_bytes_per_second
                expr: |
                  label_replace(vector(1339840), "host", "istanbul", "", "")
                  or
                  label_replace(vector(809120), "host", "rome", "", "")
                  or
                  label_replace(vector(108136),  "host", "babylon", "", "")
                  or
                  label_replace(vector(50000000),  "host", "alexandria", "", "")
              - record: host_disk_max_write_bytes_per_second
                expr: |
                  label_replace(vector(2609200), "host", "istanbul", "", "")
                  or
                  label_replace(vector(455820), "host", "rome", "", "")
                  or
                  label_replace(vector(226004),  "host", "babylon", "", "")
                  or
                  label_replace(vector(30000000),  "host", "alexandria", "", "")
      ''
    ];

    scrapeConfigs = [
      {
        job_name = "navidrome";
        static_configs = [
          {
            targets = [ "${vars.network.internal.alexandria}:${toString vars.services.navidrome.http_port}" ];
          }
        ];
        metrics_path = "/metrics_navidrome";
      }
    ];

    extraFlags = [
      "--web.enable-remote-write-receiver"
      "--storage.tsdb.retention.time=30d"
    ];
  };
}
