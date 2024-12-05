      program day1
        implicit none

#ifdef TEST
        integer, parameter :: n = 6
        character(len=8), parameter :: filename = "test.dat"
#else
        integer, parameter :: n = 1000
        character(len=8), parameter :: filename = "main.dat"
#endif
        integer :: i, j
        integer :: left(n), right(n), cnt(n)

c       Read in the two lists as arrays
        write(unit=6, fmt="('Reading ',a8)") filename
        open(unit=10, file=filename)
        do i = 1, n
          read(unit=10, fmt=100) left(i), right(i)
        end do
#ifdef TEST
 100   format(i1,3x,i1)
#else
 100   format(i5,3x,i5)
#endif
        close(unit=10)

c       Count instances of entries of the left list in the right
        cnt(:) = 0
        do i = 1, n
          do j = 1, n
            if (left(i) == right(j)) then
              cnt(i) = cnt(i) + 1
            end if
          end do
        end do

c       Take the dot product
        write(unit=6, fmt="('Part 2: ',i8)") sum(left * cnt)

c       Sort the two arrays
        call bubble_sort(left)
        call bubble_sort(right)

c       Sum the differences
        write(unit=6, fmt="('Part 1: ',i8)") sum(abs(left - right))

        contains

c         Array to apply bubble sort algorithm to an array
          subroutine bubble_sort(arr)
            integer, intent(in out) :: arr(n)
            integer :: tmp, l, k

            do l = 1, n
              do k = 1, n-1
                if (arr(k) > arr(k+1)) then
                  tmp = arr(k)
                  arr(k) = arr(k+1)
                  arr(k+1) = tmp
                end if
              end do
            end do
          end subroutine bubble_sort

      end program day1
