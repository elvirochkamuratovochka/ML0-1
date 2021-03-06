euclideanDistance = function(u, v) { return (sqrt(sum((u - v)^2))) }
kernelE = function(r) { return ((3/4*(1-r^2)*(abs(r)<=1))) }
kernelQ = function(r) { return ((15 / 16) * (1 - r ^ 2) ^ 2 * (abs(r) <= 1)) }
kernelR = function(r) { return ((0.5 * (abs(r) <= 1) )) } 
kernelT = function(r) { return ((1 - abs(r)) * (abs(r) <= 1)) }
kernelG = function(r) { return (((2*pi)^(-1/2)) * exp(-1/2*r^2)) }
ParzenWindow = function(XL, y, h, metricFunction = euclideanDistance)
{
      n = dim(xl)[1]
      weights = rep(0,3)
      names(weights) = c("setosa", "versicolor", "virginica")
      for(i in 1:n)
      {
            x = XL[i,1:2]
            class = XL[i,3]
            r = metricFunction(x,y)/h
            weights[class] = kernelG(r) + weights[class];
      }
      class = names(which.max(weights))
      if(max(weights) == 0)
      {
            return ("0")
      }
      else
      {
            return (class)
      } 
}
plotWindows = function(h)  
{
      for(i in seq(0.7, 7, 0.1))
      {
            for(j in seq(0, 3, 0.1))  
            {
                   z = c(i, j)
                   class = Parzen(xl, z, h=0.1)
                   if(class!="0") { points(z[1], z[2], pch = 1, col = colors[class]) }
                   else { points(z[1], z[2], pch = 1, col="grey") }
            } 
       }
}
plot(iris[, 3:4],main = "Ãàóññîâñêîå ÿäðî", pch = 21, bg = colors[xl$Species], col = colors[xl$Species],asp='1')
plotWindows(h)
colors = c("setosa" = "red", "versicolor" = "green", "virginica" = "blue", "0" = "0")
xl <- iris[, 3:5] 
class = iris[, 5]
