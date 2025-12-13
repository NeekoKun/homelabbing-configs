{ vars, ... }:

let
  net = vars.network;
in
{
  services.loki = {
    enable = true;

    configuration = {
      auth_enabled = false;

      server = {
        http_listen_port = vars.services.loki.http_listen_port;
        grpc_listen_port = vars.services.loki.grpc_listen_port;
      };

      common = {
        path_prefix = "/var/lib/loki";

        storage = {
          filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
        };

        replication_factor = 1;
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
      };

      schema_config = {
        configs = [{
          from = "2025-12-13";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
        ingestion_rate_mb = 16;
        ingestion_burst_size_mb = 32;
      };
    };
  };
}
