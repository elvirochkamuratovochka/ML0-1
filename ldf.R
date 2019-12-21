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

inverseSigma <- solve(sigma)
alpha <- inverseSigma %*% t(mu1 - mu2)
mu_st <- (mu1 + mu2) / 2
beta <- mu_st %*% alpha

abline(beta / alpha[2,1], -alpha[1,1]/alpha[2,1], col =
         "red", lwd = 3)
mu<-rbind(mu1,mu2)

classifier <- function(xy,m,s,lambda,Py)
{
  n <- dim(mu)[2]
  p <- rep(0,n)
  for(i in 1:n)
  {
    mu <- matrix(c(m[i,1],m[i,2]),1,2)
    det <- det(sigma)
    invsigma <- solve(sigma)
    
    b <- invsigma %*% t(mu) 
    D <- -2*b[1,1]
    E <- -2*b[2,1]
    
    F <- c(mu %*% invsigma %*% t(mu)) 
    
    func <- function(x, y) {
      f<-x*D + y*E + F
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

