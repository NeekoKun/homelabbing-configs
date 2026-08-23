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

{ config, lib, vars, pkgs, ... }:

let
  namespace = vars.network.netns.isolated-vpn;

  hostInterface = vars.network.netns.main;
  namespaceInterface = vars.network.netns.isolated-vpn;

  hostAddress = "10.200.0.1/30";
  namespaceAddress = "10.200.0.2/30";
in
{
  systemd.services."netns-${namespace}" = {
    description = "Create ${namespace} network namespace";

    wantedBy = [ "network-pre.target" ];
    before = [ "network-pre.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -eu

      ${pkgs.iproute2}/bin/ip netns add ${namespace}

      # Namespace loopback.
      ${pkgs.iproute2}/bin/ip -n ${namespace} link set lo up

      # Host <-> namespace veth pair.
      ${pkgs.iproute2}/bin/ip link add \
        ${hostInterface} \
        type veth \
        peer name ${namespaceInterface} \
        netns ${namespace}

      # Host side.
      ${pkgs.iproute2}/bin/ip addr add \
        ${hostAddress} \
        dev ${hostInterface}

      ${pkgs.iproute2}/bin/ip link set \
        ${hostInterface} \
        up

      # Namespace side.
      ${pkgs.iproute2}/bin/ip -n ${namespace} addr add \
        ${namespaceAddress} \
        dev ${namespaceInterface}

      ${pkgs.iproute2}/bin/ip -n ${namespace} link set \
        ${namespaceInterface} \
        up
    '';

    preStop = ''
      ${pkgs.iproute2}/bin/ip link delete \
        ${hostInterface} \
        2>/dev/null || true

      ${pkgs.iproute2}/bin/ip netns delete \
        ${namespace} \
        2>/dev/null || true
    '';
  };
}