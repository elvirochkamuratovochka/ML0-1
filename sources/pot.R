require("plotrix")
euclideanDistance <- function(u, v)
{
	return (sqrt(sum((u - v)^2)))
}
kernelG = function(r) { return (((2*pi)^(-1/2)) * exp(-1/2*r^2)) }

pot_func <- function(potentials,xl,y,h){
	n <- dim(xl)[1]
	w <- rep(0,3)
	names(w) <- c("setosa", "versicolor", "virginica")
	for(i in 1:n)
	{
		x <- xl[i,1:2]
		class <- xl[i,3]
		r <- euclideanDistance(x,y);
		w[class] <- potentials[i]*kernelG(r)+w[class]
		
	}
	class <- names(which.max(w))
	if(max(w)==0){
		return ("0")
	}
	else{
		return (class)
	}
}

potentials <- function(xl,class,n,h=1,errors=5){
	e <- 100
	pots <- rep(0,n)
	
	while(e>error)
	{
	
		while(TRUE){
			z <- sample(1:n,1)
			x <- xl[z,1:2]
			point <- pot_func(pots,xl,x,h)
			
			if (colors[point] != colors[class[z]]) {
				pots[z] <- pots[z] + 1
				break
			}
			
		}
		e <- 0
		for (i in 1:n) {
			x <- xl[i,1:2]
			points <- xl[-i,1:3]
			if (colors[pot_func(pots,points,x, h)]!= colors[class[i]]){
				e <- e + 1
			}
		}
	}
	return(pots)
}

drawPotentials <- function(xl, classes, potentials, h=1, colors) {
	plot(xl, bg = colors[classes], col = colors[classes], pch = 21, asp = 1)
	scalle <- potentials / max(potentials)
	for (i in 1:n) {
		x <- xl[i, 1]
		y <- xl[i, 2]
		if(scalle[i]!=0){
			color <- adjustcolor(colors[classes[i]], scalle[i]*0.2)
			draw.circle(x, y, 0.05, 30, border = "black", col = "black")
			draw.circle(x, y, h, 40, border = color, col = color)
		}
	}

}
error <- 5
h <- 1
colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue", "0" = "NA")
xl <- iris[, 3:5]
class <- iris[, 5]
n <- dim(xl)[1]
y <- rep(0,n)
pot <- potentials(xl,class,n,h,error)
drawPotentials(xl[,1:2], class, pot, h, colors)
