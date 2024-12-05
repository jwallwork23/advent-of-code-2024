program day4
  implicit none

#ifdef TEST
  integer, parameter :: n = 10
  character(len=8), parameter :: filename = "test.dat"
#else
  integer, parameter :: n = 140
  character(len=8), parameter :: filename = "main.dat"
#endif
  integer :: i, j, W(-2:n+3,-2:n+3), part1, part2, u, r
  character(len=n) :: line, wordsearch(n)

  ! Read input data
  open(unit=10, file=filename)
  do i = 1, n
    read(unit=10, fmt=100) wordsearch(i)
  end do
#ifdef TEST
  100 format(a10)
#else
  100 format(a140)
#endif
  close(unit=10)

  ! Convert puzzle input to a padded array of integers
  W(:,:) = 0
  do i = 1, n
    line = wordsearch(i)
    do j = 1, n
      if (line(j:j) == "X") then
        W(i,j) = 1
      else if (line(j:j) == "M") then
        W(i,j) = 2
      else if (line(j:j) == "A") then
        W(i,j) = 3
      else if (line(j:j) == "S") then
        W(i,j) = 4
      else
        print *, "Unexpected character", line(j:j)
        stop 999
      end if
    end do
  end do

  part1 = 0
  do i = 1, n
    do j = 1, n

      ! Only start from an X
      if (W(i,j) /= 1) then
        cycle
      end if

      ! Loop over directions and check for the other letters in a line
      do u = -1, 1
        do r = -1, 1
          if ((u /= 0) .or. (r /= 0)) then
            if ((W(i+u,j+r) == 2) .and. (W(i+2*u,j+2*r) == 3) .and. (W(i+3*u,j+3*r) == 4)) then
              part1 = part1 + 1
            end if
          end if
        end do
      end do
    end do
  end do
  print *, "Part 1: ", part1

  part2 = 0
  do i = 1, n
    do j = 1, n

      ! Only start from an A
      if (W(i,j) /= 3) then
        cycle
      end if

      ! Loop over cross orientations and check for the other letters in a line
      do u = -1, 1
        do r = -1, 1
          if (((W(i+u,j+u) == 2) .and. (W(i-u,j-u) == 4)) .and. &
              ((W(i+r,j-r) == 2) .and. (W(i-r,j+r) == 4))) then
            part2 = part2 + 1
          end if
        end do
      end do
    end do
  end do
  print *, "Part 2: ", part2

end program day4
