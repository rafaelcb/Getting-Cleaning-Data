
# The code below reads the UCI HAR Dataset, merges the test and train
# datatables and generates a tidy version for easier manipulation.
# The code also generates a separate "averages" table with the average
# value of each variable for every (Subject,Activity) pair.
# The code assumes that the data is in the working directory and that
# the "plyr" package has been installed. A description of the variables
# can be found in the README and CODEBOOK docs in the repo.


features<-read.table("features.txt")

test<-read.table("X_test.txt")
subject_test<-read.table("subject_test.txt")
y_test<-read.table("Y_test.txt")
test<-cbind(subject_test,y_test,test)
colnames(test)<-c("Subject","Activity",as.character(features[,2]))

train<-read.table("X_train.txt")
subject_train<-read.table("subject_train.txt")
y_train<-read.table("Y_train.txt")
train<-cbind(subject_train,y_train,train)
colnames(train)<-c("Subject","Activity",as.character(features[,2]))

merged<-rbind(test,train)
merged<-merged[,c(1,2,grep("mean",names(merged)),grep("std",names(merged)))]

library(plyr)
merged$Activity<-mapvalues(merged$Activity,c("1","2","3","4","5","6"),
                           c("Walking","Walking upstairs","Walking downstairs"
                             ,"Sitting","Standing","Laying"))
averages<-aggregate(merged[,3:81],by=list(merged$Subject,merged$Activity),FUN=mean)
names(averages)[1:2]<-c("Subject","Activity")
write.table(averages,file="AverageTable.txt",row.name=F)
