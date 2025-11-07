module BitboardMod
    use TypesMod
    implicit none

    private

    type, public :: Bitboard
        unsigned(uint64) :: board = 0u_uint64
    contains
        procedure, public :: print
        procedure, public :: IsSet
    end type Bitboard

    public :: Bitboard_init

contains

    ! Factory function: creates a bitboard with an initial value
    function Bitboard_init(value) result(bb)
        unsigned(uint64), intent(in) :: value
        type(Bitboard) :: bb
        bb%board = value
    end function Bitboard_init

    ! Returns true if the bit at the given square is set
    logical function IsSet(this, square)
        class(Bitboard), intent(in) :: this
        integer, intent(in) :: square
        IsSet = iand(this%board, shiftl(UINT(1, kind=uint64), square)) /= 0u_uint64
    end function IsSet

    ! Prints the bitboard
    subroutine Print(this)
        class(Bitboard), intent(in) :: this
        integer :: rank, file, square
        integer(uint64) :: board_int

        ! Convert unsigned to standard integer for printing
        board_int = int(this%board, kind=uint64)

        do rank = 7, 0, -1
            write(*,'(A)') "+---+---+---+---+---+---+---+---+"
            write(*,'(A)', advance='no') "| "
            do file = 0, 7
                square = rank*8 + file
                if (this%IsSet(square)) then
                    write(*,'(A)', advance='no') "X | "
                else
                    write(*,'(A)', advance='no') ". | "
                end if
            end do
            write(*,'(A,I0)') " ", rank+1
        end do

        write(*,'(A)') "+---+---+---+---+---+---+---+---+"
        write(*,'(A)') "  a   b   c   d   e   f   g   h"
        write(*,*)

        ! Print the board as hexadecimal
        write(*,'(A,Z16.16)') "     Board: 0x", board_int
    end subroutine Print


end module BitboardMod
