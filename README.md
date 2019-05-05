# LogGragh2
options(repos=structure(c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")))

docker run -d --rm -p 8838:3838 -v /Users/zhangshenghu/cooder/rcode/rspace:/srv/shiny-server/  -v /Users/zhangshenghu/cooder/rcode/shinylog/:/var/log/shiny-server/ rocker/shiny