program day2
  implicit none

#ifdef TEST
  integer, parameter :: m = 6
  integer, parameter :: n = 5
  character(len=8), parameter :: filename = "test.dat"
#else
  integer, parameter :: m = 1000
  integer, parameter :: n = 8
  character(len=8), parameter :: filename = "proc.dat"
#endif
  integer :: i, j, k, part1, diff, part2
  integer :: mat(m,n)
  logical :: increasing, bonus

  ! Read in data as array
  open(unit=10, file=filename)
  write(unit=6, fmt="('Input array:')")
  do i = 1, m
    read(unit=10, fmt=100) mat(i,:)
    write(unit=6, fmt=100) mat(i,:)
  end do
#ifdef TEST
  100 format(i1,4(1x,i1))
#else
  100 format(8(1x,i2))
#endif
  close(unit=10)

  ! Part 1
  part1 = 0
  do i = 1, m
    increasing = (mat(i,1) < mat(i,2))
    if (is_safe(increasing)) then
      part1 = part1 + 1
    end if
  end do
  write(unit=6, fmt="('Part 1: ',i4)") part1

  ! Part 2 ! TODO: Use is_safe here, too (will need some reworking)
  part2 = 0
  i_loop2: do i = 1, m
    increasing = (mat(i,1) < mat(i,2))
    bonus = .true.
    if (bad_diff(i,1)) then
      bonus = .false.
      mat(i,2) = mat(i,1)
      increasing = (mat(i,2) < mat(i,3))
    end if
    j_loop2: do j = 2, n-1
      if (mat(i,j+1) == 0) then
        exit j_loop2
      end if
      ! k_loop: do k = 1,2
        if (increasing .neqv. (mat(i,j) < mat(i,j+1))) then
          if (bonus) then
            bonus = .false.
            mat(i,j) = mat(i,j-1)
            ! cycle k_loop
          else
            cycle i_loop2
          end if
        end if
        if (bad_diff(i,j)) then
          if (bonus) then
            bonus = .false.
            mat(i,j) = mat(i,j-1)
            ! cycle k_loop
          else
            cycle i_loop2
          end if
        end if
      ! end do k_loop
    end do j_loop2
    part2 = part2 + 1
  end do i_loop2
  write(unit=6, fmt="('Part 2: ',i4)") part2
  ! 712 too low

  contains

    function bad_diff(idx1,idx2) result(bad)
      integer, intent(in) :: idx1, idx2
      integer :: diff
      logical :: bad

      diff = abs(mat(idx1,idx2) - mat(idx1,idx2+1))
      bad = ((diff < 1) .or. (diff > 3))
    end function bad_diff

    logical function is_safe(increasing)
      logical, intent(out) :: increasing

      do j = 1, n-1
        if (mat(i,j+1) == 0) then
          is_safe = .true.
          return
        end if
        if (increasing .neqv. (mat(i,j) < mat(i,j+1))) then
          is_safe = .false.
          return
        end if
        diff = abs(mat(i,j) - mat(i,j+1))
        if ((diff < 1) .or. (diff > 3)) then
          is_safe = .false.
          return
        end if
      end do
      is_safe = .true.
    end function is_safe

end program day2
