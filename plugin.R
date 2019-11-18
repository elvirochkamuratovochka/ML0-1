library(MASS) # Подключаем библиотеку MASS для генерации многомерного нормального распределения

# Восстановление центра нормального распределения
estimate_mu <- function(objects) {
  rows <- dim(objects)[1]
  cols <- dim(objects)[2]
  mu <- matrix(NA, 1, cols)
  for (col in 1:cols) {
    mu[1, col] = mean(objects[ ,col])
  }
  return(mu)
}

# Восстановление ковариационной матрицы нормальногораспределения
estimate_cov_matrix <- function(objects, mu) {
  rows <- dim(objects)[1]
  cols <- dim(objects)[2]
  sigma <- matrix(0, cols, cols)
  for (i in 1:rows) {
    sigma <- sigma + (t(objects[i, ] - mu) %*% (objects[i, ] - mu)) / (rows - 1)
  }
  return(sigma)
}

# Получение коэффициентов подстановочного алгоритма
get_coeffs <- function(mu1, sigma1, mu2, sigma2) {
  # Line equation: a*x1^2 + b*x1*x2 + c*x2 + d*x1 + e*x2 + f = 0
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

# Количество объектов в каждом классе
objects_count <- 300 

# Генерируем тестовые данные
Sigma1 <- matrix(c(10, 0, 0, 1), 2, 2)
Sigma2 <- matrix(c(6, 0, 0, 6), 2, 2)
Mu1 <- c(1, 0)
Mu2 <- c(15, 0)
xy1 <- mvrnorm(n = objects_count, Mu1, Sigma1)
xy2 <- mvrnorm(n = objects_count, Mu2, Sigma2)

# Собираем два класса в одну выборку
xl <- rbind(cbind(xy1, 1), cbind(xy2, 2))

# Рисуем обучающую выборку
colors <- c("blue2", "green3")
plot(xl[ , 1], xl[ , 2], pch = 21, bg = colors[xl[ ,3]], asp = 1, xlab = "x", ylab = "y")

# Оценивание
objects_first <- xl[xl[,3] == 1, 1:2]
objects_second <- xl[xl[,3] == 2, 1:2]
mu1 <- estimate_mu(objects_first)
mu2 <- estimate_mu(objects_second)
sigma1 <- estimate_cov_matrix(objects_first, mu1)
sigma2 <- estimate_cov_matrix(objects_second, mu2)
coeffs <- get_coeffs(mu1, sigma1, mu2, sigma2)

# Рисуем дискриминантую функцию
x <- y <- seq(-10, 20, len = 100)
z <- outer(x, y, function(x, y) coeffs["x^2"]*x^2 + coeffs["y^2"]*y^2 + coeffs["xy"]*x*y + coeffs["x"]*x + coeffs["y"]*y + coeffs["1"])
contour(x, y, z, levels = 0, drawlabels = FALSE, lwd = 2.5, col = "red", add = TRUE)
