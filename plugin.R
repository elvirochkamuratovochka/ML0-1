library(MASS) # Generation of multidimensional normal distribution

# Center of normal distribution
get_mu <- function(objects) {
  rows <- dim(objects)[1]
  cols <- dim(objects)[2]
  mu <- matrix(NA, 1, cols)
  for (col in 1:cols) {
    mu[1, col] = mean(objects[ ,col])
  }
  return(mu)
}

# Covariation matrix of normal distribution
get_matrix <- function(objects, mu) {
  rows <- dim(objects)[1]
  cols <- dim(objects)[2]
  sigma <- matrix(0, cols, cols)
  for (i in 1:rows) {
    sigma <- sigma + (t(objects[i, ] - mu) %*% (objects[i, ] - mu)) / (rows - 1)
  }
  return(sigma)
}


# Get coefficients of plug-in
coef <- function(mu1, sigma1, mu2, sigma2) {
  # Line equation: a*x1^2 + b*x1*x2 + c*x2 + d*x1 + e*x2 + f = 0
  # Inverse matrices

  determ1 <-det(sigma1)
  determ2 <-det(sigma2)
  a <- sigma1[2,2]/determ1
  b <- -sigma1[2,1]/determ1
  c <- -sigma1[1,2]/determ1
  d <- sigma1[1,1]/determ1

  determ1 <-det(sigma1)
  e <- sigma2[2,2]/determ2
  f <- -sigma2[2,1]/determ2
  m <- -sigma2[1,2]/determ2
  n <- sigma2[1,1]/determ2

  F <-  - log(abs(det(sigma1))) + log(abs(det(sigma2))) + mu1[1]*mu1[1]*a+(b+c)*mu1[1]*mu1[2]+d*mu1[2]*mu1[2]-mu2[1]*mu2[1]*e-(f+m)*mu2[1]*mu2[2]-mu2[2]*n
  A <- a-e
  B <- d-n
  C <- b+c+f+m
  D <- -2*mu1[1]*a-2*mu1[2]*b-mu1[1]*c+2*mu2[1]*e+f*mu2[1]+mu2[2]*m
  E <- -mu1[1]*b-mu1[1]*c-d*2*mu1[2]+f*mu2[1]+m*mu2[1]+2*mu2[2]*n
  return(c("x^2" = A, "y^2" = B, "xy" = C, "x" = D, "y" = E, "1" = F))
}

plugin <- function(x,mus,sigmas,lymda,P)
{
  n <- 2
  p <- rep(0,n)
  for(i in 1:n)
  {
    sigma <- matrix(c(sigmas[i*2-1,1],sigmas[i*2-1,2],sigmas[i*2,1],sigmas[i*2,2]),2,2)
    mu <- matrix(c(mus[i,1],mus[i,2]),1,2)
    determ <-det(sigma)
    a <- sigma[2,2]/determ
    b <- -sigma[2,1]/determ
    c <- -sigma[1,2]/determ
    d <- sigma[1,1]/determ

    F <-  - log(abs(det(sigma))) + mu[1]*mu[1]*a+(b+c)*mu[1]*mu[2]+d*mu[2]*mu[2]    
    A <- a
    B <- d
    C <- b+c
    D <- -2*mu[1]*a-2*mu[2]*b-mu[1]*c
    E <- -mu[1]*b-mu[1]*c-d*2*mu[2]

    func <- function(x, y) {
      f <- x^2*A + y^2*B + x*y*C + x*D + y*E + F
    }
    f <- func(x[1],x[2])
    p[i] <- log(l*P) - f
  }
  if(p[1] > p[2])
  {
    class <- colors[1]
  }
  else
  {
    class <- colors[2]
  }
  return(class)
}

# Count of objects in each class
objects_count <- 300

# Generation of test data
Sigma1 <- matrix(c(1, 0, 0, 4), 2, 2)
Sigma2 <- matrix(c(5, 0, 0, 1), 2, 2)
Mu1 <- c(0, 0)
Mu2 <- c(4, 0)
xy1 <- mvrnorm(n = objects_count, Mu1, Sigma1)
xy2 <- mvrnorm(n = objects_count, Mu2, Sigma2)

xl <- rbind(cbind(xy1, 1), cbind(xy2, 2))

# Рисуем обучающую выборку
colors <- c("blue2", "green3")
plot(xl[ , 1], xl[ , 2], pch = 21, bg = colors[xl[ ,3]], asp = 1, xlab = "x", ylab = "y")

objects_first <- xl[xl[,3] == 1, 1:2]
objects_second <- xl[xl[,3] == 2, 1:2]
mu1 <- get_mu(objects_first)
mu2 <- get_mu(objects_second)
sigma1 <- get_matrix(objects_first, mu1)
sigma2 <- get_matrix(objects_second, mu2)

sigma<-rbind(sigma1,sigma2)

mu<-rbind(mu1,mu2)

coeffs <- coef(mu1, sigma1, mu2, sigma2)

x <- y <- seq(-10, 20, len = 100)
z <- outer(x, y, function(x, y) coeffs["x^2"]*x^2 + coeffs["y^2"]*y^2 + coeffs["xy"]*x*y + coeffs["x"]*x + coeffs["y"]*y + coeffs["1"])
contour(x, y, z, levels = 0, drawlabels = FALSE, lwd = 2.5, col = "red", add = TRUE)


