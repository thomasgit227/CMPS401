v <- c(2.27, 2.76, 3.27, 3.31, 3.7, 3.85, 4.31, 4.39, 4.42, 4.81, 4.9, 5.05, 5.21, 5.62, 5.88)
p <- c(2500, 365, 23700, 5491, 14000, 78200, 70700, 138000, 304500, 341948, 49375, 260200, 867023, 1340000, 1092759)

#Part A
plot(v, p, pch = 16, col = "black", xlab = "Velocity (m/s)", ylab = "Population (#)", add = TRUE)
myData <- data.frame(v, p)

#Part B
expFit <- nls(p~a*v^b, data = myData, start = list(a = 10000, b = 2))

bCoefList <- coef(expFit)
a <- bCoefList[1]
b <- bCoefList[2]
curve(a*v^b, xname = "v", col = "blue", xlab = "Velocity (m/s)", ylab = "Population (#)", add = TRUE)

#Part C
lnFit <- nls(p~a*log(v), data = myData, start = list(a = 2))

cCoefList <- coef(lnFit)
a <- cCoefList[1]
curve(a*log(v), xname = "v", col = "red", xlab = "Velocity (m/s)", ylab = "Population (#)", add = TRUE)