x <- c(.5, 1, 1.5, 2, 2.5)
y <- c(.7, 3.4, 6.2, 12.4, 20.1)
myData <- data.frame(x,y)
fit <- nls(y~a*x^n, data = myData, start = list(a = 1, n = 1))
coefList <- coef(fit)
a <- coefList[1]
n <- coefList[2]

plot(x, y, pch = 16, col = "black")
lines(x, predict(fit), col = "red") #Linear Connection

plot(x, y, pch = 16, col = "black", add = FALSE)
curve(a*x^n, col = "green", add = TRUE, ) #Predicted Model