# LogGragh2

```
options(repos=structure(c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))) 

install.packages(shiny) 

install.packages(visNetwork) 

install.packages(jsonify)

install.packages(jsonlite)

```

docker run -d --rm -p 8838:3838 -v /Users/zhangshenghu/cooder/rcode/rspace:/srv/shiny-server/  -v /Users/zhangshenghu/cooder/rcode/shinylog/:/var/log/shiny-server/ rocker/shiny