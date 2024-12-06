program day6
  implicit none

#ifdef TEST
  integer, parameter :: n = 10
  character(len=8), parameter :: filename = "test.dat"
#else
  integer, parameter :: n = 130
  character(len=8), parameter :: filename = "main.dat"
#endif
  integer :: i, j, x, y, x0, y0, r, d, part1, part2
  complex :: rd, rd0
  complex, parameter :: ii = complex(0, 1)
  character(len=1) :: map(0:n+1,0:n+1)

  ! Read puzzle input as a padded map
  map(:,:) = "."
  write(unit=6, fmt="('Puzzle input:')")
  open(unit=10, file=filename)
  do i = 1, n
    read(unit=10, fmt=100) map(i,1:n)
  end do
#ifdef TEST
  100 format(10a1)
#else
  100 format(130a1)
#endif

  ! Get starting position
  rd0 = complex(0, -1)
  rd = rd0
  i_loop: do j = 1, n
    do i = 1, n
      if (map(j,i) == "^") then
        map(j,i) = "."
        x0 = i
        y0 = j
        exit i_loop
      end if
    end do
  end do i_loop

  call wander(1)
  print *, "Part 1:", part1

  part2 = 0
  do j = 1, n
    do i = 1, n
      if ((map(j,i) == "#") .or. ((i == x0) .and. (j == y0))) then
        cycle
      end if
      map(j,i) = "#"
      call wander(2)
      map(j,i) = "."
    end do
  end do
  print *, "Part 2:", part2

  contains

    ! Encode orientations as integers
    integer function encode()
      if ((r == 0) .and. (d == -1)) then
        encode = 1 ! up
      else if ((r == 1) .and. (d == 0)) then
        encode = 2 ! right
      else if ((r == 0) .and. (d == 1)) then
        encode = 3 ! down
      else if ((r == -1) .and. (d == 0)) then
        encode = 4 ! right
      end if
    end function encode

    ! Wander around the lab and count the number of unique locations
    subroutine wander(mode)
      integer, intent(in) :: mode
      logical :: visited(n,n,4) ! up, right, down, left
      integer :: orientation

      x = x0
      y = y0
      part1 = 0
      visited(:,:,:) = .false.
      visited(y,x,1) = .true.
      do while ((x >= 1) .and. (x <= n) .and. (y >= 1) .and. (y <= n))
        r = realpart(rd)
        d = imagpart(rd)

        ! Turn if there's an obstacle, else take a step
        if (map(y+d,x+r) == "#") then
          rd = rd * ii
        else
          x = x + r
          y = y + d
          if ((mode == 1) .and. (.not. any(visited(y,x,:)))) then
            part1 = part1 + 1
          end if
        end if

        ! Check for infinite loops - FIXME
        orientation = encode()
        if ((mode == 2) .and. (visited(y,x,orientation))) then
          part2 = part2 + 1
          exit
        end if

        ! Mark the location and orientation as visited
        visited(y,x,orientation) = .true.
      end do
    end subroutine wander

end program day6
