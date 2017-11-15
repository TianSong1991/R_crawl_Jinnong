#清楚环境变量
rm(list = ls())

# 加载包
library('xml2')
library('rvest')

#爬取url
url111 <- 'http://www.agri.com.cn/company/township_city_index.asp?province_id=650000'

#省份城市爬取
web<-read_html(url111,encoding="ISO-8859-1")

#城市链接获取
position<-web %>% html_nodes("a") %>% html_attr('href')

#转化为data.frame格式
test1 <- data.frame(position)

#赋值列名统一为urls
colnames(test1) <- c('urls')

#正则匹配
test1$urlsbz <- grepl(pattern = '/town/',test1$urls)

#选择/town/
test1_1 <- test1$urls[which(test1$urlsbz == TRUE)]

test1_1 <- data.frame(test1_1)

colnames(test1_1) <- c('urls')

#转化为字符型
test1_1$urls <- as.character(test1_1$urls)

#去重，可能会有重复值
test1_1 <- distinct(test1_1)

n1 <- nrow(test1_1)

binddata <- data.frame(1)

colnames(binddata) <- c('urls')

for(i in 1:n1){
  #获取第一个城市链接
  url1 <- test1_1$urls[i]
  
  web1 <- read_html(url1,encoding = 'ISO-8859-1')
  
  position1 <-web1 %>% html_nodes("a") %>% html_attr('href')
   
  test11 <- data.frame(position1)
  
  colnames(test11) <- c('urls')
  
  #获取第一个城市下,所有城镇乡村电话
  test11$urlsbz <- grepl(pattern = '/town/',test11$urls)
  
  test22 <- test11$urls[which(test11$urlsbz == TRUE)]
  
  test22 <- data.frame(test22)
  
  colnames(test22) <- c('urls')
  
  test22$urls <- as.character(test22$urls)
  
  #binddata <- rbind(binddata,test22)
  
  n2 <- nrow(test22)
  ###############第二个for循环################
  for(j in 1:n2){

    #第一个乡村界面
    url1_1 <- test22$urls[j]

    web1_1 <- read_html(url1_1,encoding = 'ISO-8859-1')

    position2 <- web1_1 %>% html_nodes("a") %>% html_attr('href')

    test33 <- data.frame(position2)

    colnames(test33) <- c('urls')

    test33$urls <- as.character(test33$urls)

    #获取出电话url
    num1 <- grep(pattern = '/tel/',test33$urls)

    url1_2 <- test33$urls[num1]

    url1_2 <- data.frame(url1_2)
    
    colnames(url1_2) <- c('urls')
  
    binddata <- rbind(binddata,url1_2)
  }
}

write.csv(binddata,'crawldata.csv')