# gfw-pac

科学上网 PAC 文件生成器。通过自定义域名和 CNIP 地址生成 PAC(Proxy auto-config) 文件。对存在于自定义域名和解析出的IP不是CNIP的域名使用代理。

**此仓库每天自动通过GitHub Action从apnic获取国内IPv4地址段并更新gfw.pac文件**

## 特性
* 速度快，优先按域名匹配，再按解析后的 IP 匹配
* 可自定义需要代理的域名
* 可自定义本地开发 TLD 域名，例如 .test
* 可自定义不需要代理的域名
* 如果访问的域名不在列表里，但是 IP 在国外，也返回代理服务器

## 用法

1. （推荐）下载并编辑 `gfw.pac` 的第一行换成自己的代理服务器直接使用。
2. 按下面说明手工运行 `gfw-pac.py` 生成自己的 pac 文件。此种方法可自定义域名流向，更灵活。但现在大多数客户端都可以定义域名匹配规则，特殊域名通过客户端定制即可。

## gfw-pac.py 使用说明

    usage: gfw-pac.py -f 输出的PAC文件名 -p 代理服务器 [-h]
                      [--user-rule 自定义使用代理域名的文件]
                      [--direct-rule 自定义直连域名域名的文件]
                      [--localtld-rule 本地TLD文件]
                      [--ip-file APNIC下载的delegated文件]

参数说明：

    -h 显示帮助
    -f (必须)输出的 pac 文件
    -p (必须)指定代理服务器，例如 PROXY 192.168.1.1:3128
    --user-rule 自定义使用代理的域名文件，文件里每行一个域名
    --direct-rule 自定义不使用代理的域名文件，文件里每行一个域名
    --localtld-rule 自定义不使用代理的顶级域，文件里每行一个域名，必须带前导圆点（例如 .test）
    --ip-file 指定本地的从 apnic 下载的 IP 分配文件。若不指定则自动从 apnic 下载

举例：

    ./gfw-pac.py -f gfw.pac \
                 -p "PROXY 192.168.1.200:3128; DIRECT" \
                 --user-rule=custom-domains.txt \
                 --direct-rule=direct-domains.txt \
                 --localtld-rule=local-tlds.txt \
                 --ip-file=delegated-apnic-latest.txt

## 技巧

* 若自动下载 APNIC 的 IP 分配文件很慢，可自行用科学办法下载 <https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest> 后，用 `--ip-file` 参数指定下载好的文件。
* 自行解决 DNS 污染问题。
* 代理工具最好也配置 GEOIP 规则。
