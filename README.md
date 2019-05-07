# LogGragh2

## preinstall

```
options(repos=structure(c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))) 

install.packages("shiny") 

install.packages("visNetwork") 

install.packages("jsonify")

install.packages("jsonlite")

```

## run in docker shiny server

``` 
docker run -d --rm -p 8838:3838 -v /cooder/rcode/rspace:/srv/shiny-server/  -v /cooder/rcode/shinylog/:/var/log/shiny-server/ rocker/shiny
```