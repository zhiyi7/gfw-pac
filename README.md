# gfw-pac

科学上网 PAC 文件以及生成器。通过自定义域名和 CNIP 地址生成 PAC(Proxy auto-config) 文件。对存在于自定义域名和解析出的IP不是CNIP的域名使用代理，支持IPv6。

**此仓库每 7 天自动通过 GitHub Action 从 `Loyalsoldier/geoip` 获取国内地址段并更新 `gfw.pac` 文件**

## 特性
* 开箱即用，直接可用的 `gfw.pac` 包含了常用的直连域名和代理域名以及国内IPv4/IPv6地址段
* IP规则前置：若域名解析出的 IP 地址属于国内，返回直连，流量不经过代理程序
* 速度快：优先按域名匹配，高频访问域名节省解析时间。IP段匹配使用Radix Tree，时间复杂度仅为O(m) _m<=32(IPv4) 或者 m<=128(IPv6)_
* 不误伤：仅添加非常少的高频域名，减少流量走向错误的概率。
* 支持 IPv6，不再需要为了IP规则而关闭IPv6或者AAAA解析，可正常开启IPv6，享受v6带来的各种便利。
* 纯 IP 地址能正确处理，使用DoH的APP可完全正常工作。
* 支持 iOS/MacOS/Windows/Android、Chrome/Edge/Firefox。生成的 pac 文件体积小，脚本全部使用ES5，大多数现代系统可正常执行。
* 可自定义需要代理的域名
* 可自定义直连的域名
* 可自定义直连的 TLD 域名，例如 .test

## 用法

1. （**推荐**）下载并编辑 `gfw.pac` 的第一行换成自己的代理服务器直接使用。
2. 按下面说明手工运行 `gfw-pac.py` 生成自己的 pac 文件。此种方法可自定义域名流向，更灵活。但现在大多数客户端都可以定义域名匹配规则，特殊域名通过客户端定制即可。

## gfw-pac.py 使用说明

    usage: gfw-pac.py -f 输出的PAC文件名 -p 代理服务器 [-h]
                      [--proxy-domains 自定义使用代理域名的文件]
                      [--direct-domains 自定义直连域名域名的文件]
                      [--localtld-domains 本地TLD文件]
                      [--ip-file 从 Loyalsoldier/geoip/blob/release 中下载的 text/cn.txt 文件]

参数说明：

    -h 显示帮助
    -f (必须)输出的 pac 文件
    -p (必须)指定代理服务器，例如 PROXY 192.168.1.1:3128
    --proxy-domains 自定义使用代理的域名文件，文件里每行一个域名
    --direct-domains 自定义直连的域名文件，文件里每行一个域名
    --localtld-domains 自定义直连的顶级域，文件里每行一个域名，必须带前导圆点（例如 .test）
    --ip-file 从 Loyalsoldier/geoip release 中下载的 text/cn.txt 文件

举例：

    ./gfw-pac.py -f gfw.pac \
                 -p "PROXY 192.168.1.200:3128; DIRECT" \
                 --proxy-domains=proxy-domains.txt \
                 --direct-domains=direct-domains.txt \
                 --localtld-domains=local-tlds.txt \
                 --ip-file=cidrs-cn.txt

## 代理工具普遍支持配置路由规则，为什么还要用 pac 文件？

现代系统（MacOS/iOS/Windows）底层网络框架都会自动执行pac策略，使得大多数应用的http请求能够使用代理，而不仅仅是供浏览器使用。如果依赖于代理工具的路由规则，所有流量都进入代理程序，即使命中代理的直连规则，网络流量也要经过代理程序转发，性能会受影响。而先由网络框架通过 pac 文件决定用代理还是直连后，直连的流量不再经过代理程序，性能更好。当前所有流行代理前端几乎都内置了 pac 文件，当选择代理前端提供的“pac模式”的时候，代理前端会将系统代理脚步设置为它自动生成的 pac 文件。

## 跟代理工具提供的 pac 文件有什么不一样？

维护 pac 文件并不是代理工具的优先工作。一些代理工具提供的 pac 文件在不断融合的过程中包含了广告过滤、隐私保护等太多内容，以及体积庞大到无人可维护的域名列表，年久失修导致非常容易漏掉或者误伤。另一个极端则是仅有非常少的规则，大多数流量还是进入了客户端，甚至都不支持IPv6。而这个 pac 文件仅添加访问频率最高的域名，可以明确知道哪些域名直连、哪些域名代理，域名列表没有的再通过 IP 地址段匹配确认，可以保证99%以上的国内流量不进入代理程序。

## 技巧

* 自行解决 DNS 污染问题。
* 经常来下载包含最新数据的 pac 文件。
* 代理工具最好也配置 GEOIP/GEOSITE 等路由规则（及时更新数据的前提下）。