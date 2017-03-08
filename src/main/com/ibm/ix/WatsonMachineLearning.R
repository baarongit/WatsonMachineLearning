# The base code for the Watson Machine Learning custom node.
# 
# Author: baaron
###############################################################################
#modelerData contains the original input data
#modelerDataModel contains new data
# Install function for packages    
packages <- function(x){
	x <- as.character(match.call()[[2]])
	if (!require(x,character.only=TRUE)){
		install.packages(pkgs=x,repos="http://cran.r-project.org")
		require(x,character.only=TRUE)
	}
}
packages(jsonlite)
packages(httr)
packages(xml2)
#modelerData contains the original input data
#modelerDataModel contains new data
#assemble the content from the original data
base <-"%%url%%" 
context<-"%%context%%"
token<-"%%token%% " 
url <- paste(base,context ,'?accesskey=',token,sep='')
df <- modelerData
header <- c()
data <- c()
results <- c()
for(i in 1:nrow(df)){
	row<-df[i,]
	for(i in names(df)){
		header<-append(header,i)
		data<-append(data,toString(row[[i]]))
	}
	body = sprintf('{"tablename":"scoreInput","header":%s,"data":[%s]}',toJSON(header),toJSON(data))
	r <- POST(url, body = body, encode="json",accept("application/json"),content_type("application/json"))
	content_list <- content(r)
	header <- c()
	data <- c()
	results<-append(results,content_list[[1]]$data[[1]][[21]])
}
results<-data.frame(cbind(results))
modelerData<-cbind(modelerData,results)
X21<-c(fieldName="GAME_STYLE_ID",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",fieldRole="none")
modelerDataModel<-data.frame(modelerDataModel,X21)
