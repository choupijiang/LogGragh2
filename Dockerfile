# from rocker-org/shiny

FROM rocker/shiny:latest 
# Author: Zhangshenghu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q libmariadbclient-dev libmariadb-client-lgpl-dev

RUN  R -e "install.packages('visNetwork', repos='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')"
RUN  R -e "install.packages('jsonify', repos='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')"
RUN  R -e "install.packages('jsonlite', repos='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')"
RUN  R -e "install.packages('RMySQL', repos='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')"

EXPOSE 9838
