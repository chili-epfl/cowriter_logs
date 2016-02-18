### function to compute frequency of transition

library(markovchain)
library(shape)
library(diagram)

norm <- function(x){
  x/sum(x)
}

super_plot = function(mat){
  
  plotmat(mat,
        cex.txt = 0.6,
        box.size = 0.06,
        box.type = "circle",
        box.prop = 0.5,
        box.col = "light yellow",
        arr.length=.15,
        arr.width=.1,
        self.cex = .5,
        self.shifty = -.01,
        self.shiftx = .15,
        main = "")
}

frequencies <- function(eventCol, targets , seuil=0.1){
  
  vec = unique(eventCol)
  nb_states = length(vec)
  stays = matrix(1,nb_states,dimname=list(vec))
  moves = matrix(1,nb_states,nb_states, dimnames = list(vec,vec))
  nb_trans = length(eventCol)-1
  c=0
  for (i in 1:nb_trans) {
    
    event = eventCol[i]
    new_event = eventCol[i+1]
    if ((event=="+" || event=="-" || event=="send")&&new_event=="send"){
      c=c+1
    }
    else{
      moves[event,new_event] = moves[event,new_event]+1
      if (event==new_event){
        if (event %in% targets){
          stays[event] = stays[event]+1
          moves[event,event] = moves[event,event]-1
        }
      }
    }
  }
  
  movesN = apply(moves,1,norm)
  movesN[movesN<seuil]=0
  
  super_plot(movesN)
  
  return(stays)
}


  

plotmat(mc@transitionMatrix,
        cex.txt = 0.8,
        box.size = 0.1,
        box.type = "circle",
        box.prop = 0.5,
        box.col = "light yellow",
        arr.length=.1,
        arr.width=.1,
        self.cex = .4,
        self.shifty = -.01,
        self.shiftx = .13,
        main = "")

