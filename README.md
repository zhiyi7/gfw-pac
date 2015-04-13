# gfw-pac

通过 gfwlist 和中国 IP 地址生成 PAC(Proxy auto-config) 文件。对存在于 gfwlist 的域名和解析出的 IP 在国外的域名使用代理。

基于 [GFWList2PAC](https://github.com/clowwindy/gfwlist2pac) 和 [Flora PAC](https://github.com/Leask/Flora_Pac)

## 特性
* 速度快，优先按域名匹配，再按 IP 匹配
* 可自定义需要代理的域名
* 可自定义不需要代理的域名
* 如果访问的域名不在列表里，但是 IP 在国外，也返回代理服务器

## 用法

直接使用 `gfw.pac`，或者手工运行 `gfw-pac.py` 生成自己的 pac 文件。

## gfw-pac.py 使用说明

    usage: gfw-pac.py [-h] [-i GFWLIST] -f PAC -p PROXY [--user-rule USER_RULE]
                      [--direct-rule DIRECT_RULE] [--ip-file IP_FILE]

参数说明：

    -h 显示帮助
    -i 指定本地 gfwlist 文件，若不指定则自动从 googlecode 下载
    -f (必须)输出的 pac 文件
    -p (必须)指定代理服务器
    --user-rule 自定义使用代理的域名文件，文件里每行一个域名
    --direct-rule 自定义不使用代理的域名文件，文件里每行一个域名
    --ip-file 指定本地的从 apnic 下载的 IP 分配文件。若不指定则自动从 apnic 下载

举例：

    ./gfw-pac.py -i gfwlist.txt \
                 -f gfw.pac \
                 -p "PROXY 192.168.1.200:3128; DIRECT" \
                 --user-rule=custom-domains.txt \
                 --direct-rule=direct-domains.txt \
                 --ip-file=delegated-apnic-latest.txt

[一路凯歌 技术博客](http://zhiyi.us)