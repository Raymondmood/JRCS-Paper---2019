#clear session
rm(list=ls())

# Load dataset generated by freq.py (Jeff Heaton's program for creating shopping transaction data)
mydata1 = read.delim("/home/ubuntu/Paper_Nov/Add_Datasets/test1.txt", sep ="", header = F ,
                     na.strings ="", stringsAsFactors= F)

mydata1[is.na(mydata1)] <- ""
mydata1$Name = rownames(mydata1)
cols = ncol(mydata1)
mydata1 = mydata1[,c(cols,2:cols-1)]


write.csv(mydata1,"/home/ubuntu/Paper_Nov/Add_Datasets/ItemList.csv", row.names = TRUE)
trans=read.transactions("/home/ubuntu/Paper_Nov/Add_Datasets/ItemList.csv", format="basket", sep=",", rm.duplicates=TRUE)

Minsup_in = 0.1 # Set this lower than the required min support to catch as many rules as possible 
Minconf = 0.1 

start.time <- Sys.time()

rules = apriori(trans, parameter = list(support = Minsup_in, conf = Minconf, maxtime = 100, target = "rules"))

end.time <- Sys.time()

time.taken <- end.time - start.time # calculates the run time of the Apriori algorithm


#clean-up#####################
rules = as(rules, "data.frame")
df = rules$rules
df = as.data.frame(df)
df1 = cSplit(df, c("df"), c("}"))
df1 = cSplit(df1, c("df_1"), c(","))

s<-gsub("*.\\{","\\1",df1$df_2)
s<-gsub("*.>","\\1",s)
s = as.data.frame(s)

p<-gsub("^.","\\1",df1$df_1_1)
p = as.data.frame(p)

df1 <- df1[, -c(1:2)]
df1 = cbind(p, df1, s)

rules <- rules[, -c(1)]
rules = cbind(df1,rules)

write.csv(mydata1,"/home/ubuntu/Paper_Nov/Add_Datasets/ItemList_test.csv", row.names = TRUE)

# Use this to compute mt
write.csv(rules,"/home/ubuntu/Paper_Nov/Add_Datasets/rules_test.csv", row.names = TRUE)

