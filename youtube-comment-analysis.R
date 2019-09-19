#Getting youtube data
library(SocialMediaLab)

#Youtube developer API
apikey<- "XXXXXXXX"
key<- AuthenticateWithYoutubeAPI(apikey)

#Collect video data
video<- c("6sbPGzrXbts", "Lem7KgAb9SY")
ytdata<- CollectDataYoutube(video, key,writeToFile = FALSE)
str(ytdata)
write.csv(ytdata, file='yt.csv', row.names = FALSE)

#read youtube data file
data<- read.csv(file.choose(), header = T)
str(data)
data<- data[data$ReplyToAnotherUser != FALSE,]
y<- data.frame(data$User, data$ReplyToAnotherUser)


#Create user network
library(igraph)
net<- graph.data.frame(y, directed = T)
net<- simplify(net)
V(net)
E(net)
V(net)$label<- V(net)$name
V(net)$degree<- degree(net)

#Histogram of node degree
hist(V(net)$degree, col='green', main='Histogram of node degree', ylab='Frequency', xlab='Degree of Vertices')

#Network diagram
plot(net, vertex.size=0.2*V(net)$degree, edge.arrow.size=0.1, vertex.label.cex=0.01*V(net)$degree)


#Sentiment analysis
library(syuzhet)

#Read data file
data<- read.csv(file.choose(), header=T)
comments<- iconv(data$Comment, to='utf-8')

#Sentiment scores
s<- get_nrc_sentiment(comments)
head(s)
s$neutral<- ifelse(s$negative+s$positive==0,1,0)
head(s)

#Barplot
library(ggplot2)
barplot(100*colSums(s)/sum(s), las=2, col=rainbow(11), ylab='Percentage', main='Sentiment Score of Youtube videos')
ggplot(aes(100*colSums(s)/sum(s)), geom_bar())

