program dayX
  implicit none

#ifdef TEST
  integer, parameter :: n = 6
  character(len=8), parameter :: filename = "test.dat"
#else
  integer, parameter :: n = 1000
  character(len=8), parameter :: filename = "main.dat"
#endif
  integer :: i, j

end program dayX
