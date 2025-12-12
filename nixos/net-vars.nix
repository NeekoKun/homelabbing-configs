{
  interfaces = {
    wan = "enp0s3":
    lan = "enp0s8";
  };

  internal = {
    subnet = "192.168.2.0/24";
    mask = "255.255.255.0";
    gateway = "192.168.2.1";
  };
}
