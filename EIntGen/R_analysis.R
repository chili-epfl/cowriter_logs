library(psych)
require(ggplot2)
library(gplots)

##########################
##### WITHMENESS ANALYISIS
##########################
all_withmeness <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_withmeness.csv")
View(all_withmeness)
attach(all_withmeness)

all_withmeness$session <- as.factor(session)
all_withmeness$child_id <- as.factor(child_id)

head(all_withmeness)
describeBy(withmeness_value, group=session)
describeBy(withmeness_value, group=fformation)
describeBy(withmeness_value, group=gender)
describeBy(withmeness_value, group=alone)


paired <- subset(all_withmeness, (alone=='no'))
alones <- subset(all_withmeness, (alone=='yes'))
f2fs <- subset(all_withmeness, (fformation=='f2f'))
sbss <- subset(all_withmeness, (alone=='sbs'))

#extract children that actually passed the 2 session
child2session <- subset(all_withmeness, ((child_id>=1) & (child_id<=8)) | (child_id==10) | (child_id>=22))
all_withmeness <- child2session
current <- f2fs
p <- ggplot(current, aes(x=idx, y=withmeness_value, color=child_id))+ facet_wrap(~child_id, ncol=4)
p + stat_smooth()

### fformation : sbs or f2f
p <- ggplot(all_withmeness, aes(factor(all_withmeness$fformation),withmeness_value))
p + geom_boxplot(aes(fill=factor(all_withmeness$fformation))) 
p + stat_summary(fun.y="mean", geom="bar")
plotmeans(withmeness_value~fformation,xlab="F Formation", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.fformation = aov(withmeness_value~fformation+Error(child_id/fformation),all_withmeness)
summary(aov.fformation)
print(model.tables(aov.fformation,"means"),digits=3)  

### group or alone
p <- ggplot(all_withmeness, aes(factor(all_withmeness$alone),withmeness_value))
p + geom_boxplot(aes(fill=factor(all_withmeness$alone))) 
plotmeans(withmeness_value~alone,xlab="Alone ?", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.alone = aov(withmeness_value~alone+Error(child_id/alone),all_withmeness)
summary(aov.alone)
print(model.tables(aov.alone,"means"),digits=3)  

### session order
p <- ggplot(all_withmeness, aes(factor(all_withmeness$session),withmeness_value))
p + geom_boxplot(aes(fill=factor(all_withmeness$session))) 
plotmeans(withmeness_value~session,xlab="Session order", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.session = aov(withmeness_value~session+Error(child_id/session),all_withmeness)
summary(aov.session)
print(model.tables(aov.session,"means"),digits=3)  


### gender
p <- ggplot(all_withmeness, aes(factor(all_withmeness$gender),withmeness_value))
p + geom_boxplot(aes(fill=factor(all_withmeness$gender))) 
plotmeans(withmeness_value~gender,xlab="Gender", ylab="Withmeness Value", main="with 95% CI") #plot means with error bars
#anova
aov.gender = aov(withmeness_value~gender+Error(child_id/gender),all_withmeness)
summary(aov.gender)
print(model.tables(aov.gender,"means"))  


### interactions
interaction.plot(fformation, alone, withmeness_value, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="F Fomration",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Group / FFormation")

interaction.plot(gender, alone, withmeness_value, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Gender / Group")

interaction.plot(fformation, session, withmeness_value, type="b", col=c(1:3),
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),
                 xlab="Gender",
                 ylab="Withmeness", ylim =c(0,1),
                 main="Interaction Plot \n Session / FFormation")
aov.fomation_session = aov(withmeness_value~(fformation*session)+Error(child_name/(fformation*session)),all_withmeness)
summary(aov.fomation_session)
print(model.tables(aov.fomation_session,"means"))

interaction.plot(fformation, gender, withmeness_value, type="b", col=c(1:3),
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
