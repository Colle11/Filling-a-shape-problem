% Problem: Filling a shape
%
% Consider a figure whose outer edges are defined by a sequence of points (e.g., (0,0),(0,2),(2,2),(2,5),(4,5),(4,1),(2,1),(2,0)).
% You have as many as you need "L" pieces (the biggest border is of size 2) plus unitary "U" pieces. "L" pieces can rotate (in the
% same plane, they cannot be turned upside down - "U" pieces can rotate as well, but it doesn't matter too much).
% The goal is to fill the internal shape of the figure, without overlapping the pieces minimizing the overall number of pieces used.
%
% By Michele Collevati

% width of the input points bounding box
width(W) :- W = #max{ X : point(X,Y) }.

% height of the input points bounding box
height(H) :- H = #max{ Y : point(X,Y) }.

% x coordinates
coord_x(1..W) :- width(W).

% y coordinates
coord_y(1..H) :- height(H).

% Keep only the cells that belong to the shape.
% Let C be a cell.
% Let N be the number of points having x and y coordinates lower than C's coordinates.
% IF N is even THEN C does NOT belong to the shape
% ELSE (N is odd) C belongs to the shape
cell(C) :- coord_x(CX), coord_y(CY), width(W),
           PS = #count{ PX,PY : point(PX,PY), PX < CX, PY < CY },
           PS \ 2 == 1,
           C = (CY - 1) * W + CX.

% A cell filled by a "L" piece can NOT even be filled by a "U" piece.
n_u_piece(A) :- cell(A), cell(B), cell(C), l_piece(A,B,C).
n_u_piece(B) :- cell(A), cell(B), cell(C), l_piece(A,B,C).
n_u_piece(C) :- cell(A), cell(B), cell(C), l_piece(A,B,C).

% A cell filled by a "U" piece can NOT even be filled by a "L" piece.
n_l_piece(A,B,C) :- cell(A), cell(B), cell(C), u_piece(A).
n_l_piece(A,B,C) :- cell(A), cell(B), cell(C), u_piece(B).
n_l_piece(A,B,C) :- cell(A), cell(B), cell(C), u_piece(C).

% To form "L" pieces: the index of the cell in the middle of the piece
% is 1 and W respectively distant from the index of the other two cells.
% Symmetry breaker: in l_piece(A,B,C)
% A is the cell in the middle of the piece
% B is the cell distant 1 from the cell in the middle of the piece
% C is the cell distant width from the cell in the middle of the piece
0 { l_piece(A,B,C) } 1 :- cell(A), cell(B), cell(C), width(W),
                          |A - B| == 1, |A - C| == W,
                          not n_l_piece(A,B,C).

% "U" pieces
u_piece(A) :- cell(A), not n_u_piece(A).

% A cell can be filled by at most 1 "L" piece.
:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(C,A,B), l_piece(C,D,E), A != D.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(C,A,B), l_piece(C,D,E), B != E.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(A,C,B), l_piece(D,C,E), A != D.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(A,C,B), l_piece(D,C,E), B != E.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(A,B,C), l_piece(D,E,C), A != D.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(A,B,C), l_piece(D,E,C), B != E.

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(C,A,B), l_piece(D,C,E).

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(C,A,B), l_piece(D,E,C).

:- cell(C), cell(A), cell(B), cell(D), cell(E),
   l_piece(A,C,B), l_piece(D,E,C).

% To prevent non-legal "L" pieces: a cell with multiple index
% of the width can NOT form a "L" piece with the next cell,
% because they are NOT adjacent in the bounding box.
:- cell(A), cell(B), cell(C), width(W),
   l_piece(A,B,C),
   A \ W == 0,
   B == A + 1.

:- cell(A), cell(B), cell(C), width(W),
   l_piece(A,B,C),
   A \ W == 1,
   B == A - 1.

% Number of "U" pieces
num_u_pieces(NUP) :- NUP = #count{ A : cell(A), u_piece(A) }.

% Number of "L" pieces
num_l_pieces(NLP) :- NLP = #count{ A,B,C : cell(A), cell(B), cell(C), l_piece(A,B,C) }.

% Minimize the number of "U" pieces
#minimize { NUP : num_u_pieces(NUP) }.

% Maximize the number of "L" pieces
%#maximize { NLP : num_l_pieces(NLP) }.

#show l_piece/3.
#show u_piece/1.
#show num_u_pieces/1.
#show num_l_pieces/1.