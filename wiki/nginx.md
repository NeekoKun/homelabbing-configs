#service/nginx #host/istanbul #status/active
## Abstract
> [!abstract] Role
> - Nginx is this repo's choice for a reverse proxy. It will manage both proxying to the same machine, as well as to other machines on the LAN network
> - Nginx will also manage SSH over HTTPS to avoid some network's "security" approaches like blocking SSH traffic
> - Lastly, the TLS will _most likely_ terminate in an nginx block

## Proxy chain
- First, packets are filtered through ssl_preread and matched by SNI
	- If the SNI is `contacts.neekokun.com`, the connection is forwarded to [[stunnel]] for decryption on `127.0.0.1:8022`
		- [[stunnel]] decrypts the connection and hands it to [[sslh]] on `127.0.0.1:2222`, which decides if the packets are HTTP or SSH
			- SSH connections are handed to [[sshd]] on `127.0.0.1:2`
			- HTTP connections are routed back to nginx on `127.0.0.1:8222` for the `contacts.neekokun.com` vHost
	- For any other SNI, the stream is forwarded to `127.0.0.1:8443` which is the default [[nginx]] rproxy for different vHosts
		- [[nginx]] terminates SSL and hands the TCP socket to the respective processes
## Proxied services
### [[Grafana]]
Proxied from `grafana.neekokun.com` to [[Rome]]

### [[Wiki]]
A static webpages served by nginx itself

## [[Vaultwarden]]
Proxied from `vaultwarden.neekokun.com` to [[Alexandria]]