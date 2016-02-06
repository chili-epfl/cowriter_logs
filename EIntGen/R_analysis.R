library(psych)
require(ggplot2)
library(gplots)

##########################
##### WITHMENESS ANALYISIS
##########################
all_withmeness <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_withmeness_r.csv")
View(all_withmeness)
attach(all_withmeness)

all_withmeness$session <- as.factor(session)
all_withmeness$child_id <- as.factor(child_id)

head(all_withmeness)
describeBy(new_w, group=session)
describeBy(new_w, group=fformation)
describeBy(new_w, group=gender)
describeBy(new_w, group=alone)


paired <- subset(all_withmeness, (alone=='no'))
alones <- subset(all_withmeness, (alone=='yes'))
f2fs <- subset(all_withmeness, (fformation=='f2f'))
sbss <- subset(all_withmeness, (alone=='sbs'))

#extract children that actually passed the 2 session
all_withmeness$session <- as.factor(session)
all_withmeness$child_id <- as.integer(child_id)
child2session <- subset(all_withmeness, ((child_id>=1) & (child_id<=8)) | (child_id==10) | (child_id>=22))
all_withmeness <- child2session

current <- f2fs
p <- ggplot(all_withmeness, aes(x=idx))+ facet_wrap(~child_name, ncol=4)
p + stat_smooth(aes(y=new_w,  color=fformation)) 
p+ stat_smooth(aes(y=new_w))
p + geom_line(aes(y=new_w,color=fformation))

stat_withme <- summarySE(all_withmeness, measurevar="new_w", groupvars=c("fformation","session","alone","gender","chouchou"))


### fformation : sbs or f2f
p <- ggplot(stat_withme, aes(x=factor(all_withmeness$fformation),y=new_w, colour=fformation, fill=fformation),ylim=c(0,1))
p + geom_boxplot(aes(fill=factor(all_withmeness$fformation))) 
p + stat_summary(fun.y="mean", geom="bar")
p+ stat_summary(fun.data=mean_cl_normal,position=position_dodge(0.95),geom="errorbar") 
p+  stat_summary(fun.y=mean,position=position_dodge(width=0.95),geom="bar") 
attach(stat_withme)
p+ geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=new_w-se, ymax=new_w+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))

plotmeans(new_w~fformation,xlab="F Formation", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.fformation = aov(new_w~fformation+Error(child_id/fformation),all_withmeness)
summary(aov.fformation)
print(model.tables(aov.fformation,"means"),digits=3)  

### group or alone
p <- ggplot(all_withmeness, aes(factor(all_withmeness$alone),new_w))
p + geom_boxplot(aes(fill=factor(all_withmeness$alone))) 
plotmeans(new_w~alone,xlab="Alone ?", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.alone = aov(new_w~alone+Error(child_id/alone),all_withmeness)
summary(aov.alone)
print(model.tables(aov.alone,"means"),digits=3)  

### session order
p <- ggplot(all_withmeness, aes(factor(all_withmeness$session),new_w))
p + geom_boxplot(aes(fill=factor(all_withmeness$session))) 
plotmeans(new_w~session,xlab="Session order", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.session = aov(new_w~session+Error(child_id/session),all_withmeness)
summary(aov.session)
print(model.tables(aov.session,"means"),digits=3)  


### gender
p <- ggplot(all_withmeness, aes(factor(all_withmeness$gender),new_w))
p + geom_boxplot(aes(fill=factor(all_withmeness$gender))) 
plotmeans(new_w~gender,xlab="Gender", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.gender = aov(new_w~gender+Error(child_id/gender),all_withmeness)
summary(aov.gender)
print(model.tables(aov.gender,"means"))  


### interactions
interaction.plot(fformation, alone, new_w, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="F Fomration",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Group / FFormation")

interaction.plot(gender, alone, new_w, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Gender / Group")

interaction.plot(fformation, session, new_w, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Session / FFormation")
aov.fomation_session = aov(new_w~(fformation*session)+ Error(child_id/session),all_withmeness)
summary(aov.fomation_session)
print(model.tables(aov.fomation_session,"means"))

interaction.plot(fformation, gender, new_w, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Gender / FFormation")

##########################
##### TARGETS ANALYISIS
##########################
all_targets <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_targets.csv")
View(all_targets)
attach(all_targets)
all_targets$session <- as.factor(session)
all_targets$child_id <- as.factor(child_id)

#extract children that actually passed the 2 session
child2session <- subset(all_targets, ((child_id>=1) & (child_id<=8)) | (child_id==10) | (child_id>=22))
all_targets <- child2session
f2fs <- subset(all_targets, (fformation=='f2f'))
sbss <- subset(all_targets, (fformation=='sbs'))

pie(summary(f2fs$target,col=rainbow(5), main="# of targets"))
pie(summary(sbss$target,col=rainbow(5), main="# of targets"))

s1 <- subset(all_targets, (session=='1'))
s2 <- subset(all_targets, (session=='2'))

pie(summary(s1$target,col=rainbow(5), main="# of targets"))
pie(summary(s2$target,col=rainbow(5), main="# of targets"))

ta


##########################
##### USER FEEDBACK
##########################
all_userfeeback <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_userfeeback.csv")
View(all_userfeeback)
attach(all_userfeeback)

#extract children that actually passed the 2 session
child2session <- subset(all_userfeeback, ((child_id>=1) & (child_id<=8)) | (child_id==10) | (child_id>=22))
all_userfeeback <- child2session
all_userfeeback$session <- as.factor(session)
all_userfeeback$child_id <- as.factor(child_id)


p <- ggplot(all_userfeeback, aes(fformation))
p + geom_bar(aes(fill = feedback))
p <- ggplot(all_userfeeback, aes(session))
p + geom_bar(aes(fill = feedback))
p <- ggplot(all_userfeeback, aes(gender))
p + geom_bar(aes(fill = feedback))


interaction.plot(fformation, session, new_w, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Session / FFormation")


plotmeans(new_w~gender,xlab="Gender", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
describe.by()



##########################
##### TIME ANALYSIS
##########################
all_timelogs <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_timelogs.csv")
View(all_timelogs)
attach(all_timelogs)
all_timelogs$child_id <- as.integer(child_id)
child2session <- subset(all_timelogs, ((child_id>=1) & (child_id<=8)) | (child_id==10) | (child_id>=22))
all_timelogs <- child2session
all_timelogs$session <- as.factor(session)
all_timelogs$child_id <- as.factor(child_id)

##fformation
p <- ggplot(all_timelogs, aes(x=idx))+ facet_wrap(~child_name, ncol=4)
p + stat_smooth(aes(y=responset,  color=fformation)) 
p + stat_smooth(aes(y=writingt,  color=fformation)) 

plotmeans(responset~fformation,xlab="F Formation", ylab="Response time", main="with 95% CI") #plot means with error bars
plotmeans(writingt~fformation,xlab="F Formation", ylab="Writing time", main="with 95% CI") #plot means with error bars

p <- ggplot(all_timelogs, aes(factor(all_timelogs$fformation), responset))
p + geom_boxplot(aes(fill=factor(all_timelogs$fformation))) 

p <- ggplot(all_timelogs, aes(factor(all_timelogs$fformation), writingt))
p + geom_boxplot(aes(fill=factor(all_timelogs$fformation))) 



##session
p <- ggplot(all_withmeness, aes(factor(all_withmeness$session),new_w))
p + geom_boxplot(aes(fill=factor(all_withmeness$session))) 



########################### HELPING FUNCTIONS
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}
