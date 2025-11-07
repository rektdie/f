program f
    use BitboardMod
    use TypesMod
    implicit none

    type(Bitboard) :: bb
    bb = Bitboard_init(UINT(65535, kind=uint64))
    call bb%Print()

end program f
