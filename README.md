
## Метрические методы классификации

Методы обучения, основанные на анализе сходства объектов,  будем называть ***метрическими***.
 
Пусть на множестве объектов X задана функция расстояния *ρ: X × X → (0,∞)*.  Существует целевая зависимость y* :  X → Y, значения которой известны только на объектах обучающей выборки <img src="https://github.com/temirkayaeva/ML0/blob/master/images/03803ad3e8b46f76831df83fd1a51e98.png" width="230">
Множество классов Y конечно. Требуется построить алгоритм классификации *a : X → Y* , аппроксимирующий целевую зависимость y*(x) на всём множестве X. Если мы выберем любой объект из X и расположим элементы обучающей выборки в порядке возрастания до этого элемента, то получим перенумерованную выборку: <img src="https://github.com/temirkayaeva/ML0/raw/master/images/1.png" width="20"> -  i-тый сосед объекта *u*.

*Метрический алгоритм классификации* с обучающей выборкой Xl относит объект u к тому классу y ∈ Y , для которого суммарный вес ближайших обучающих объектов Γy(u, Xl) максимален: <img src="https://github.com/temirkayaeva/ML0/raw/master/images/2.png" width="500">
где весовая функция <img src="https://github.com/temirkayaeva/ML0/raw/master/images/3.png" width="45">  оценивает степень важности *i*-го соседа для классификации объекта *u*.

 
## Алгоритм 1NN

**Алгоритм ближайшего соседа - 1NN** (nearest neighbor, NN)  является самым простым алгоритмом классификации. Он относит классифицируемый объект <img src="https://github.com/temirkayaeva/ML0/raw/master/images/4.png" width="45"> к тому классу, которому принадлежит ближайший обучающий объект: <img src="https://github.com/temirkayaeva/ML0/raw/master/images/5.png" width="100">

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/1nn1.png" width="900"> 
  
#### Достоинства метода

* Простота реализации.

#### Недостатки метода

* Неустойчивость к погрешностям (шуму, выбросам).
* Отсутствие настраиваемых параметров.
* Низкое качество классификации.
* Приходится хранить всю выборку целиком.

## Алгоритм KNN

**В алгоритме k ближайших соседей - KNN** (k nearest neighbors) объекты классифицируются  путем *голосования* по *k* ближайшим соседям. Каждый из соседей <img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn1.png" width="120">  голосует за отнесение
объекта <img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn2.png" width="15">  к своему классу <img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn3.png" width="19">. Алгоритм относит объект  <img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn2.png" width="15">  к тому классу, который
наберёт большее число голосов:
<img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn4.png" width="350"> 

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/knn.png" width="900"> 

### Оптимизация числа соседей k

Оптимальное значение параметра *k* определяют по критерию скользящего контроля с *исключением объектов по одному* (leave-one-out, LOO).
 Для каждого объекта <img src="https://github.com/temirkayaeva/ML0/raw/master/images/loo1.png" width="70">  проверяется,
правильно ли он классифицируется по своим *k* ближайшим соседям.

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/loo2.png" width="400"> 

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/looo1.png" width="900">

Оптимальное *k* = 6.

#### Достоинства метода

* Простота реализации.

#### Недостатки метода

* При k = 1 неустойчивость к погрешностям. Если среди обучающих объектов *выброс* - объект, находящийся в окружении объектов чужого класса, то не только он сам будет классифицирован неверно, но и те окружающие его объекты, для которых он окажется ближайшим.

* При k = l алгоритм наоборот чрезмерно устойчив и вырождается в константу.
 
* Бедный набор параметров.

*  Максимальная сумма голосов может достигаться на нескольких классах одновременно.

## Алгоритм k взвешенных ближайших соседей

В данном алгоритме вводится строго убывающая последовательность вещественных весов <img src="https://github.com/temirkayaeva/ML0/raw/master/images/kwnn1.png" width="19">,  задающих вклад i-го соседа в классификацию:

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/kwnn2.png" width="350"> 

#### Выбор последовательности

* <img src="https://github.com/temirkayaeva/ML0/raw/master/images/kwnn3.png" width="90"> — линейно убывающие веса; при данном выборе последовательности неоднозначности также могут возникать (например: классов два; первый и четвёртый сосед голосуют за класс 1, второй и третий — за класс 2; суммы голосов совпадают).

* <img src="https://github.com/temirkayaeva/ML0/raw/master/images/kwnn4.png" width="100"> —  экспоненциально убывающие веса (геометрическая прогрессия), *q* — параметр алгоритма. Его можно подбирать по критерию LOO, аналогично числу соседей k.

## Метод парзеновского окна

Ещё один способ задать веса соседям — определить  <img src="https://github.com/temirkayaeva/ML0/raw/master/images/kwnn1.png" width="19"> как функцию  не от ранга соседа *i*, а как функцию от расстояния <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno1.png" width="60">. Для этого вводится  функция ядра  <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno2.png" width="28"> невозрастающую на <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno3.png" width="28"> и рассматривается алгоритм: 

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno4.png" width="350"> 

Параметр *h* называется шириной окна и играет примерно ту же роль, что и число соседей *k*. "Окно" — это сферическая окрестность объекта *u* радиуса *h*, при попадании в которую обучающий объект <img src="https://github.com/temirkayaeva/ML0/raw/master/images/loo1.png" width="60"> "голосует" за отношение объекта *u* к классу <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno6.png" width="16">. Параметр *h* можно задавать или определять по скользящему контролю (LOO). 

Обучающие объекты  могут быть неравномерно распределены по пространству *X*. В окрестности одних объектов может оказываться очень много соседей, а в окрестности других — ни одного. В этих случаях применяется *окно переменной ширины*: 

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno5.png" width="350"> 

## Метод потенциальных функций

Ядро помещается в каждый обучающий объект <img src="https://github.com/temirkayaeva/ML0/raw/master/images/loo1.png" width="60">  и "притягивает" объект *u* к классу <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno6.png" width="16">, если он попадает в его окрестность радиуса <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions1.png" width="15">:

<img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions.png" width="400"> 

**Идея метода**: если обучающий объект  <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions2.png" width="16"> классифицируется неверно, то потенциал класса <img src="https://github.com/temirkayaeva/ML0/raw/master/images/okno6.png" width="16"> недостаточен в точке <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions2.png" width="16">, и вес <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions3.png" width="16"> увеличивается на единицу. 

#### Достоинства метода

* Эффективность (когда обучающие объекты поступают потоком, и хранить их в памяти нет возможности или необходимости)

#### Недостатки метода

* Недленно сходится

* Результат обучения зависит от порядка предъявления объектов

*  Слишком грубо (с шагом 1) настраиваются веса <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions3.png" width="16"> 

* Не настраиваются параметры <img src="https://github.com/temirkayaeva/ML0/raw/master/images/pfunctions2.png" width="16">

Следовательно,  данный алгоритм не может похвастаться высоким качеством классификации.


