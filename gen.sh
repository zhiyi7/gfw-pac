#!/usr/bin/env sh

PROXY_DOUBAN='PROXY tunnel.douban.com:8118;HTTPS tunnel.douban.com:8443;DIRECT'
# PROXY_LOCAL='SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080; DIRECT;'
PROXY_LOCAL='PROXY 127.0.0.1:8118;HTTPS 127.0.0.1:8118;DIRECT'

gen_pac() {
  ./gfw-pac.py -i gfwlist.txt --direct-rule direct-domains.txt --user-rule custom-domains.txt -p "$PROXY_DOUBAN" -f douban.pac
  ./gfw-pac.py -i gfwlist.txt --direct-rule direct-domains.txt --user-rule custom-domains.txt -p "$PROXY_LOCAL" -f kada.pac
}

gen_pac
