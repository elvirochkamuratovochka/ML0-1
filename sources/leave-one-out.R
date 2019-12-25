euclideanDistance <- function(u, v) {
  sqrt(sum((u - v)^2))
} ## Евклидово расстояние

l <- dim(iris)[1] ## Количество элементов выборки

knn <- function(iris_new, point, k){ ##Применяем метод kNN
  
  xl <- iris_new[, 3:5]
  n <- dim(xl)[2] - 1 
  
  distances <- matrix(NA, l, 2) ## Матрица расстояния

  for(i in 1:l) {
    distances[i, ] <- c(i, euclideanDistance(xl[i, 1:n], point))  ## Расстояние от классифицируемой точки до остальных точек выборки
  }
  orderedxl <- xl[order(distances[ , 2]), ] ## Сортировка
  classes <- orderedxl[1:k, n + 1]   ## Получаем классы первых k соседей
  counts <- table(classes) ## Составляем таблицу встречаемости каждого класса
  class <- names(which.max(counts)) ## Находим класс, который доминирует среди первых соседей
  return (class)
}

plot(NULL, NULL, type = "l", xlim = c(0, 150), ylim = c(0, 1), main = "Ãðàôèê LOO(k)", xlab = 'k', ylab = 'LOO')
step <- 5
Ox <- seq(from = 1, to = 150, by = step) 
Oy <- c()

LOO_opt <- 1
k_opt <- 1
for(k in Ox) {
  error <- 0
  for(i in 1:l) {
    iris_new <- iris[-i, ] ## Выборка без i-го элемента
    point <- iris[i, 3:4]
    if(knn(iris_new, point, k) != iris[i, 5]) { ## Если алгоритм ошибся, то счетчик ошибок увеличить на 1
      error <- error + 1
    } 
  }
  LOO <- error/l 
  Oy <- c(Oy, LOO)
  
  if(LOO < LOO_opt) {
    LOO_opt <- LOO
    k_opt <- k
  }
}

print(Ox)
print(Oy)
print(k_opt)

lines(Ox, Oy, pch = 8, bg = "black", col = "black")
points(k_opt, LOO_opt, pch = 22, bg = "black", col = "black")
