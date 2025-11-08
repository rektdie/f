module BoardMod
    use TypesMod
    use BitboardMod

    implicit none

    type, public :: Board
        logical :: stm = White

        type(Bitboard), dimension(6) :: pieces
        type(Bitboard), dimension(2) :: colors

        type(Bitboard) :: occupied


    end type Board

end module BoardMod