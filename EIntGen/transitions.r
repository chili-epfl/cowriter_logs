
targets <- read.csv("~/Documents/cowriter_logs/EIntGen/all_targets.csv", header=FALSE)
buttons <- read.csv("~/Documents/cowriter_logs/EIntGen/all_userbutton.csv", header=FALSE)

### combind data

col1 = c("V2","V5","V6","V7","V9" ,"V11")
n = nrow(targets)
targets = targets[2:n,col1]
targets = rename(targets, c("V2"="time", "V5"="session", "V6"="f2f", "V7"= "alone", "V9"="gender", "V11" = "event"))

col2 = c("V2","V5","V6","V7","V9" ,"V11")
n = nrow(buttons)
buttons = buttons[2:n,col2]
buttons = rename(buttons, c("V2"="time", "V5"="session", "V6"="f2f", "V7"= "alone", "V9"="gender", "V11" = "event"))

events = rbind(targets,buttons)

### sort by time

events[] <- lapply(events, as.character)
events = events[order(events$time),]

dyn_buttons = subset(events,events$event %in% c("new_word","+","-"))
events = subset(events,events$event %in% c("send","+","-","tablet","selection_tablet","robot_head","experimenter"))

### the subset of interest:

sess1 = subset(events, events$session==1)
sess2 = subset(events, events$session==2)

face = subset(events, events$f2f=="f2f")
side = subset(events, events$f2f=="sbs")

face_buttons = subset(dyn_buttons, dyn_buttons$f2f=="f2f")
side_buttons = subset(dyn_buttons, dyn_buttons$f2f=="sbs")

### compute frequency
frequencies(events$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)
frequencies(face$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)
frequencies(side$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)

frequencies(sess1$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)
frequencies(sess2$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)

frequencies(face_buttons$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.05)
frequencies(side_buttons$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.05)


library(plyr)
######################################################
buttons <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/all_userbutton.csv")
scores <- read.csv("~/Documents/CODING/CoWriter/cowriter_logs/EIntGen/scores_evol.csv")
### combind data
buttons = buttons[c("datetime","child_name","session","fformation","button")] 
buttons = rename(buttons, c( "button" = "event"))
scores = scores[c("datetime","child_name","session","f2f","evol_score")] 
scores = rename(scores, c("f2f"="fformation", "evol_score" = "event"))

events = rbind(scores,buttons)

### sort by time

events[] <- lapply(events, as.character)
events = events[order(events$datetime),]

events = subset(events,events$event %in% c("send","+","-","S+","S-","S=","new_word"))
events = subset(events,events$event %in% c("+","-","S+","S-","S=","new_word"))
### the subset of interest:
attach(events)
sess1 = subset(events, events$session==1)
sess2 = subset(events, events$session==2)

face = subset(events, events$f2f=="f2f")
side = subset(events, events$f2f=="sbs")

face_buttons = subset(dyn_buttons, dyn_buttons$f2f=="f2f")
side_buttons = subset(dyn_buttons, dyn_buttons$f2f=="sbs")

### compute frequency
frequencies(events$event,c("S+","S-","S=","new_word","-","+"),seuil=0.15)
frequencies(face$event,c("S+","S-","S=","new_word","-","+","send"),seuil=0.10)
frequencies(side$event,c("S+","S-","S=","new_word"),seuil=0.15)

frequencies(sess1$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)
frequencies(sess2$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)

frequencies(face_buttons$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.05)
frequencies(side_buttons$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.05)

frequencies(events$event,c("tablet","selection_tablet","robot_head","experimenter"),seuil=0.15)