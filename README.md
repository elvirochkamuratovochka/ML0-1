## Метод ближайшего соседа и его обобщения

Пусть на множестве объектов X задана функция расстояния ρ:X×X→[0,∞).Существует целевая зависимость y∗:X→Y, значения которой известны только на объектах обучающей выборки Xℓ= (xi,yi)ℓi=1,yi=y∗(xi). Множество классов Y конечно. Требуется построить алгоритм классификации нa: X→Y, аппроксимирующий целевую зависимость y ∗(x) на всём множестве X.

```R
euclideanDistance <- function(u, v)
{
sqrt(sum((u - v)^2))
}
```


