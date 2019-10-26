colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
plot(iris[, 3:4], pch = 21, bg = colors[iris$Species], col = colors[iris$Species], asp = 1, main ="KwNN")

euclideanDistance <- function(u, v) 
{
  sqrt(sum((u - v) ^ 2))
}

sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance)
{
   l <- dim(xl)[1] 
   n <- dim(xl)[2] - 1
   distances <- matrix(NA, l, 2) 
   for (i in 1:l) 
   {
      distances[i,] <- c(i, metricFunction(xl[i, 1:n], z))
   }
   orderedXl <- xl[order(distances[, 2]),] 
   return (orderedXl)
}
  
kwNN <- function(xl, z, k, q) 
{ 
  orderedXl <- sortObjectsByDist(xl, z) 
  n <- dim(orderedXl)[2] - 1 
  m <- matrix(c('setosa','versicolor', 'virginica', 0, 0, 0), nrow = 3, ncol = 2)
  
  for(i in 1:k){ 
    orderedXl[i, 4] = q^i 
  } 
  classes <- orderedXl[1:k, (n+1):(n+2)]
  
  m[1,2]=sum(classes[classes$Species=='setosa', 2])
  m[2,2]=sum(classes[classes$Species=='versicolor', 2])
  m[3,2]=sum(classes[classes$Species=='virginica', 2])
  class <- m[,1][which.max(m[,2])]
  return (class) 
}

   xl <- iris[, 3:5] 
   for(x in seq(1,7,0.1)){
    for(y in seq(0,2.5,0.1)){
    z <- c(x, y)
    class <- kwNN(xl, z, k=7, q=0.8) 
    points(z[1], z[2], pch = 1, col = colors[class], asp = 1)     
  } 
}