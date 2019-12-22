library(MASS) # Generation of multidimensional normal distribution
ObjectsCountOfEachClass <- 300

estimateFisherCovarianceMatrix <- function(objects1,
                                           objects2, mu1, mu2)
{
  rows1 <- dim(objects1)[1]
  rows2 <- dim(objects2)[1]
  rows <- rows1 + rows2
  cols <- dim(objects1)[2]
  sigma <- matrix(0, cols, cols)
  for (i in 1:rows1)
  {
    sigma <- sigma + (t(objects1[i,] - mu1) %*%
                        (objects1[i,] - mu1)) / (rows + 2)
  }
  for (i in 1:rows2)
  {
    sigma <- sigma + (t(objects2[i,] - mu2) %*%
                        (objects2[i,] - mu2)) / (rows + 2)
  }
  return (sigma)
}

estimateMu <- function(xl)
{

	m <- dim(xl)[2]
	mu <- matrix(NA, 1, m)
	
	for(i in 1:m)
	{
		mu[1,i] <- mean(xl[,i])
	}
	
	return(mu)	
}

Sigma1 <- matrix(c(2, 0, 0, 2), 2, 2)
Sigma2 <- matrix(c(2, 0, 0, 2), 2, 2)
Mu1 <- c(1, 0)
Mu2 <- c(15, 0)
xy1 <- mvrnorm(n=ObjectsCountOfEachClass, Mu1, Sigma1)
xy2 <- mvrnorm(n=ObjectsCountOfEachClass, Mu2, Sigma2)

xl <- rbind(cbind(xy1, 1), cbind(xy2, 2))

colors <- c("blue", "green2")
plot(xl[,1], xl[,2], pch = 21, bg = colors[xl[,3]], asp = 1)

objectsOfFirstClass <- xl[xl[,3] == 1, 1:2]
objectsOfSecondClass <- xl[xl[,3] == 2, 1:2]
mu1 <- estimateMu(objectsOfFirstClass)
mu2 <- estimateMu(objectsOfSecondClass)
sigma <- estimateFisherCovarianceMatrix(objectsOfFirstClass, objectsOfSecondClass, mu1, mu2)
mu<-rbind(mu1,mu2)

classifier <- function(xy,m,s,lambda,Py)
{
  n <- dim(mu)[2]
  p <- rep(0,n)
  for(i in 1:n) {
   mu <- matrix(c(m[i,1],m[i,2]),1,2)
   det <- det(sigma)
   a <- sigma[2,2]/det
   b <- -sigma[2,1]/det
   c <- -sigma[1,2]/det
   d <- sigma[1,1]/det

   A <- -2*mu[1]*a-mu[2]*b-mu[2]*c #x
   B <- -mu[1]*b-mu[2]*c-2*mu[2]*d #y
   C <- a*mu[1]^2 + mu[1]*mu[2]*b+ mu[1]*mu[2]*c+ d*mu[2]^2
    
    func <- function(x, y) {
      f<-x*A + y*B + C
    }
    f<-func(xy[1],xy[2])
    p[i] <- log(lambda*Py) - f
  }
  if(p[1] > p[2])
  {
    class<-colors[1]
  }
  else
  {
    class<-colors[2]
  }
  return(class)
}

drawline <- function(mu1,mu2,sigma) {
inverseSigma <- solve(sigma)
alpha <- inverseSigma %*% t(mu1 - mu2)
mu_st <- (mu1 + mu2) / 2
beta <- mu_st %*% alpha

abline(beta / alpha[2,1], -alpha[1,1]/alpha[2,1], col = "red", lwd = 3)

}

x <- -10
while(x < 40)
{
  y <- -10
  while(y < 40)
  {
    xy <- c(x,y)
    c <- classifier(xy,mu,sigma,lambda=1,P=0.5)
    points(xy[1],xy[2], col=c)
    y <- y+0.5
  }
  x <- x+0.5
}


drawline(mu1,mu2,sigma)

