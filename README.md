
## Метрические методы классификации

Методы обучения, основанные на анализе сходства объектов,  будем называть *метрическими*.
 
Пусть на множестве объектов X задана функция расстояния *ρ: X × X → (0,∞)*.  Существует целевая зависимость y* :  X → Y, значения которой известны только на объектах обучающей выборки ![Image alt](https://github.com/temirkayaeva/ML0/raw/master/images/03803ad3e8b46f76831df83fd1a51e98.png)
Множество классов Y конечно. Требуется построить алгоритм классификации *a : X → Y* , аппроксимирующий целевую зависимость y*(x) на всём множестве X. Если мы выберем любой объект из X и расположим элементы обучающей выборки в порядке возрастания до этого элемента, то получим перенумерованную выборку: ![Image alt](https://github.com/temirkayaeva/ML0/raw/master/images/1.png) -  i-тый сосед объекта *u*.

*Метрический алгоритм классификации* с обучающей выборкой Xl относит объект u к тому классу y ∈ Y , для которого суммарный вес ближайших обучающих объектов Γy(u, Xl) максимален:
![Image alt](https://github.com/temirkayaeva/ML0/raw/master/images/2.png)
где весовая функция ![Image alt](https://github.com/temirkayaeva/ML0/raw/master/images/3.png) оценивает степень важности *i*-го соседа для классификации объекта *u*.

 
## Алгоритм ближайшего соседа

Алгоритм ближайшего соседа относит классифицируемый объект *u ∈ X<sup>ℓ* к тому классу, которому принадлежит ближайший обучающий объект: 
  
#### Достоинства метода

* Простота реализации.

#### Недостатки метода

* Неустойчивость к погрешностям (шуму, выбросам).
* Отсутствие настраиваемых параметров.
* Низкое качество классификации.
* Приходится хранить всю выборку целиком.

## Алгоритм k-ближайших соседей

Метод *k*-ближайших соседей (англ. *k-nearest neighbors algorithm*, k-NN) — метрический алгоритм для автоматической классификации объектов или регрессии.

В случае использования метода для классификации объект присваивается тому классу, который является наиболее распространённым среди *k* соседей данного элемента, классы которых уже известны. В случае использования метода для регрессии, объекту присваивается среднее значение по *k* ближайшим к нему объектам, значения которых уже известны.

Алгоритм может быть применим к выборкам с большим количеством атрибутов (многомерным). Для этого перед применением нужно определить функцию расстояния; классический вариант такой функции — евклидова метрика.


#### Достоинства метода

* Простота реализации.

#### Недостатки метода

* Неустойчивость к погрешностям. Если среди обучающих объектов *выброс* - объект, находящийся в окружении объектов чужого класса, то не только он сам будет классифицирован неверно, но и те окружающие его объекты, для которых он окажется ближайшим.

* Отсутствие параметров, которые можно было бы настраивать по выборке. Алгоритм полностью зависит от того, насколько удачно выбрана метрика *ρ*.


