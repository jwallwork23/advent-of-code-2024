all: real

test:
	gfortran -cpp -DTEST solve.f
	./a.out

real:
	gfortran -cpp solve.f
	./a.out
