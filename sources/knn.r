colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
plot(iris[, 3:4], pch = 21, bg = colors[iris$Species], col = colors[iris$Species], asp = 1, main ="KNN")

## Евклидово расстояние
euclideanDistance <- function(u, v)
{
sqrt(sum((u - v)^2))
}

## Сортируем объекты согласно расстояния до объекта z
sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance) ## задаем функцию расстояния
{
l <- dim(xl)[1]
n <- dim(xl)[2] - 1

distances <- matrix(NA, l, 2)## задаем матрицу расстояния
for (i in 1:l)
{
distances[i, ] <- c(i, metricFunction(xl[i, 1:n], z)) ## считаем расстояние от классифицируемой точки до остальных точек выборки
}

orderedXl <- xl[order(distances[, 2]), ] ##сортируем
return (orderedXl);
}

##Применяем метод kNN
kNN <- function(xl, z, k)
{

orderedXl <- sortObjectsByDist(xl, z) ## Сортируем выборку согласно классифицируемого объекта
n <- dim(orderedXl)[2] - 1

classes <- orderedXl[1:k, n + 1] ## Получаем классы первых k соседей
counts <- table(classes) ## Составляем таблицу встречаемости каждого класса
class <- names(which.max(counts)) ## Находим класс, который доминирует среди первых соседей
return (class) ## возвращаем класс
}

## Классификация одного заданного объекта
z <- c(4, 2)
xl <- iris[, 3:5]
class <- kNN(xl, z, k=6)
points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

