# _                         _            
#| |                       | |           
#| |__   __ _ _ __ ___  ___| |_ ___ _ __ 
#| '_ \ / _` | '_ ` _ \/ __| __/ _ \ '__|
#| | | | (_| | | | | | \__ \ ||  __/ |   
#|_| |_|\__,_|_| |_| |_|___/\__\___|_| 
#
#                     _          _      _     
#                    | |        (_)    | |    
# ___  __ _ _ __   __| |_      ___  ___| |__  
#/ __|/ _` | '_ \ / _` \ \ /\ / / |/ __| '_ \ 
#\__ \ (_| | | | | (_| |\ V  V /| | (__| | | |
#|___/\__,_|_| |_|\__,_| \_/\_/ |_|\___|_| |_|
#
#        _           _
#      (`-`;-"```"-;`-`)
#       \.'         './
#       /             \
#       ;   0     0   ;
#      /| =         = |\
#     ; \   '._Y_.'   / ;
#    ;   `-._ \|/ _.-'   ;
#   ;        `"""`        ;
#   ;    `""-.   .-""`    ;
#   /;  '--._ \ / _.--   ;\
#  :  `.   `/|| ||\`   .'  :
#   '.  '-._       _.-'   .'
#   (((-'`  `"""""`   `'-)))
#
#                    _.---._
#                _.-~       ~-._
#            _.-~               ~-._
#        _.-~                       ~---._
#    _.-~                                 ~\
# .-~                                    _.;
# :-._                               _.-~./
# }-._~-._                   _..__.-~_.-~ )
# `-._~-._~-._              /   ...-~H.-~
#     ~_...._\.        _.-~ .::::  //
#         ~-. \`--...--~ _.-~__...==~
#            \.`--...---+-~~~~~
#              ~-..----~



library(reticulate)
library(readxl)


# read csv file into a data frame
data <- read.csv("results.csv")
print(data)

hamsterImages <- subset(data, Hamster >= 0.5) # recognized as a hamster
sandwichImages <- subset(data, Sandwich >= 0.5) # recognized as a sandwich

hamsterProb <- mean(hamsterImages$Hamster)
SandwichProb <- mean(sandwichImages$Sandwich)
print(hamsterProb)
print(SandwichProb)

graphSub <- sprintf("%s%f%s%f", "Hamster avg = ", hamsterProb, "     |     Sandwich avg = ", SandwichProb)

# graph the data
plot(data,col="blue", main="Image Recognition Certainty", sub=graphSub)













