objectCounter <- 500

naiv <- function(x, mu, sigma, lamda, P){
	n <- 2
	res <- log(lamda*P)
	
	for(i in 1 : n){
		pyj <- (1/(sigma[i]*sqrt(2*pi))) * exp(-1 * ((x[i] - mu[i])^2)/(2*sigma[i]^2))
    	res <- res + log(pyj)
	}
	
	return(res)
}

get_mu <- function(xl){

	l <- dim(xl)[1] 
	return(c(sum(xl[,1])/l, sum(xl[,2])/l))
  
}

get_sigma <- function(xl, mu){

	l <- dim(xl)[1] 
	return(c(sum((xl[,1] - mu[1])^2)/l, sum((xl[,2] - mu[2])^2)/l))
	
}

library(MASS)
sigma1 <- matrix(c(2, 0, 0, 2),2,2)
sigma2 <- matrix(c(1, 0, 0, 1),2,2)

mu1 <- c(0,0)
mu2 <- c(4,4)

x1 <- mvrnorm(n = objectCounter, mu1, sigma1)
x2 <- mvrnorm(n = objectCounter, mu2, sigma2)

xy1 <- cbind(x1,1) 
xy2 <- cbind(x2,2) 
  
xl <- rbind(xy1,xy2)

colors <- c("blue", "green2")
plot(xl[,1],xl[,2], pch = 21,main = "Наивный байесовский классификатор", col = colors[xl[,3]], asp = 1, bg=colors[xl[,3]])
  
mu1 <- get_mu(x1)
mu2 <- get_mu(x2)     

sigma1 <- get_sigma(x1, mu1)
sigma2 <- get_sigma(x2, mu2)
  
x1 <- -15;

while(x1 < 20){
	x2 <- -8;
    
    while(x2 < 13){          
    	
    z <- c(x,y)
    p1 <- naiv(xy,mu1,sigma1,lambda=1,P=0.5)
    p2 <- naiv(xy,mu2,sigma2,lambda=1,P=0.5)
    if(p1<p2)
    {
      points(z[1],z[2], col=colors[1])
    }
    else
    {
      points(z[1],z[2],pch=21, col=colors[2])
    	x2 <- x2 + 0.2
    }
x1 <- x1 + 0.2
}
