all: real

test:
	gfortran -cpp -DTEST solve.F90
	./a.out

real:
	gfortran -cpp solve.F90
	./a.out
