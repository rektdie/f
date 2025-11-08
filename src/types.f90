module TypesMod
    use iso_fortran_env, only: uint64
    implicit none

    public :: uint64

    character(len=*), parameter :: StartingFen = &
         "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    ! Colors
    logical, parameter :: White = .false.
    logical, parameter :: Black = .true.

    ! Pieces
    enum, bind(C)
        enumerator :: Pawn = 0
        enumerator :: Knight
        enumerator :: Bishop
        enumerator :: Rook
        enumerator :: Queen
        enumerator :: King
    end enum

    character(len=1), dimension(12), parameter :: pieceLetters = [ &
        'P','p', &
        'N','n', &
        'B','b', &
        'R','r', &
        'Q','q', &
        'K','k' ]

    ! Castling rights
    enum, bind(C)
        enumerator :: whiteKingRight = 1
        enumerator :: whiteQueenRight = 2
        enumerator :: blackKingRight = 4
        enumerator :: blackQueenRight = 8
    end enum

    ! Files
    enum, bind(C)
        enumerator :: f_A = 0
        enumerator :: f_B
        enumerator :: f_C
        enumerator :: f_D
        enumerator :: f_E
        enumerator :: f_F
        enumerator :: f_G
        enumerator :: f_H
    end enum

    integer(kind=uint64), dimension(8), parameter :: files = (/ &
        int(Z'0101010101010101', kind=uint64), &
        int(Z'0202020202020202', kind=uint64), &
        int(Z'0404040404040404', kind=uint64), &
        int(Z'0808080808080808', kind=uint64), &
        int(Z'1010101010101010', kind=uint64), &
        int(Z'2020202020202020', kind=uint64), &
        int(Z'4040404040404040', kind=uint64), &
        int(Z'8080808080808080', kind=uint64) /)

    ! Ranks
    enum, bind(C)
        enumerator :: r_1 = 0
        enumerator :: r_2
        enumerator :: r_3
        enumerator :: r_4
        enumerator :: r_5
        enumerator :: r_6
        enumerator :: r_7
        enumerator :: r_8
    end enum

    integer(kind=uint64), dimension(8), parameter :: ranks = (/ &
        int(Z'00000000000000FF', kind=uint64), &
        int(Z'000000000000FF00', kind=uint64), &
        int(Z'0000000000FF0000', kind=uint64), &
        int(Z'00000000FF000000', kind=uint64), &
        int(Z'000000FF00000000', kind=uint64), &
        int(Z'0000FF0000000000', kind=uint64), &
        int(Z'00FF000000000000', kind=uint64), &
        int(Z'FF00000000000000', kind=uint64) /)

    ! Squares
    enum, bind(C)
        enumerator :: a1 = 0, b1, c1, d1, e1, f1, g1, h1
        enumerator :: a2, b2, c2, d2, e2, f2, g2, h2
        enumerator :: a3, b3, c3, d3, e3, f3, g3, h3
        enumerator :: a4, b4, c4, d4, e4, f4, g4, h4
        enumerator :: a5, b5, c5, d5, e5, f5, g5, h5
        enumerator :: a6, b6, c6, d6, e6, f6, g6, h6
        enumerator :: a7, b7, c7, d7, e7, f7, g7, h7
        enumerator :: a8, b8, c8, d8, e8, f8, g8, h8
    end enum

    character(len=2), dimension(0:63), parameter :: squareCoords = [ &
        "a1","b1","c1","d1","e1","f1","g1","h1", &
        "a2","b2","c2","d2","e2","f2","g2","h2", &
        "a3","b3","c3","d3","e3","f3","g3","h3", &
        "a4","b4","c4","d4","e4","f4","g4","h4", &
        "a5","b5","c5","d5","e5","f5","g5","h5", &
        "a6","b6","c6","d6","e6","f6","g6","h6", &
        "a7","b7","c7","d7","e7","f7","g7","h7", &
        "a8","b8","c8","d8","e8","f8","g8","h8" ]

    ! Directions
    enum, bind(C)
        enumerator :: north =  8
        enumerator :: east  =  1
        enumerator :: south = -8
        enumerator :: west  = -1

        enumerator :: noWe =  7 
        enumerator :: noEa =  9
        enumerator :: soWe = -9
        enumerator :: soEa = -7
    end enum

end module TypesMod