total <- read.csv("~/Documents/cowriter_logs/EIntGen/letter_scores/total.csv", header=FALSE)
#View(total)

infos <- read.csv("~/Documents/cowriter_logs/EIntGen/sessions_info.csv", header=FALSE)

library(plyr)
total = rename(total, c("V1"="time", "V2"="name", "V3"="letter","V4"="chouchou", "V5"="score", "V6"="feedback","V7"="session","V8"="f2f"))

alone = subset(infos, infos$V10=="yes")

total = subset(total, is.nan(total$score)==FALSE)


########## f2f vs sbs

stat_score = summarySE(total,measurevar = 'score',groupvars='f2f')
attach(stat_score)

# Error bars represent standard error of the mean
#png(paste(total,'score_condition.png',sep=""), width=600,height=800)

ggplot(stat_score, aes(x=f2f, y=score, fill=f2f)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("1", "2"), labels=c("Cond1", "Cond2")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))

########### chouchou vs nonchouchou

stat_score = summarySE(total,measurevar = 'score',groupvars='chouchou')
attach(stat_score)

# Error bars represent standard error of the mean
#png(paste(total,'score_condition.png',sep=""), width=600,height=800)

ggplot(stat_score, aes(x=chouchou, y=score, fill=chouchou)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("1", "2"), labels=c("nonfavorite", "favorite")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))

########### s1 vs s2

children_s2 = c("alexandra","amelia","avery","daniel","enzo",
                "gaia","ines","jake","lamonie","markus",
                "osborne","oscar")

two_sess = subset(total, total$name %in% children_s2)

stat_score = summarySE(two_sess,measurevar = 'score',groupvars='session')
attach(stat_score)

# Error bars represent standard error of the mean
#png(paste(total,'score_condition.png',sep=""), width=600,height=800)

ggplot(stat_score, aes(x=chouchou, y=score, fill=chouchou)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("1", "2"), labels=c("nonfavorite", "favorite")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))

########### alone vs nonalone

two_sess = subset(total, total$name %in% alone$V2)

stat_score = summarySE(two_sess,measurevar = 'score',groupvars='session')
attach(stat_score)

# Error bars represent standard error of the mean
#png(paste(total,'score_condition.png',sep=""), width=600,height=800)

ggplot(stat_score, aes(x=chouchou, y=score, fill=chouchou)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("1", "2"), labels=c("nonfavorite", "favorite")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))

########### alone vs nonalone in sess1

sess1 = subset(total, total$session=="1")

sess1$alone = sess1$name %in% alone$V2

stat_score = summarySE(sess1,measurevar = 'score',groupvars='alone')
attach(stat_score)

# Error bars represent standard error of the mean
#png(paste(total,'score_condition.png',sep=""), width=600,height=800)

ggplot(stat_score, aes(x=alone, y=score, fill=alone)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("TRUE", "FALSE"), labels=c("alone", "not alone")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))

################# score vs alone in session1 and f2f

face = subset(sess1,sess1$f2f=='True')

describeBy(face$score, group=face$alone)

aov.score.alone = aov(face$score~face$alone,data=face)
summary(aov.score.alone)

stat_score = summarySE(face,measurevar = 'score',groupvars='alone')
attach(stat_score)

ggplot(stat_score, aes(x=alone, y=score, fill=alone)) +
  geom_bar(width=0.7, stat="identity") +
  geom_errorbar(aes(ymin=score-se, ymax=score+se), width=.3,position=position_dodge(.5))+
  scale_fill_brewer(palette = "Set3") +
  scale_x_discrete(name= "",breaks=c("TRUE", "FALSE"), labels=c("alone", "not alone")) +
  theme(legend.position="none") + ylab("score (s)")+ theme(text = element_text(size=20))
