% Instance generator for the problem "Filling a shape"
%
% Given as input a width and a height are returned in output, as a sequence of points
% starting from (0,0), all the possible shapes having that width and height.
%
% By Michele Collevati

% Constants
#const w = 3. % width
#const h = 4. % height
#const p = 0.  % percentage

% width of the shape
width(w).

% height of the shape
height(h).

% area of the rectangle containing the shape
area(A) :- width(W), height(H),
           A = W * H.

% A percentage p of the rectangle cells
% belongs to the shape.
percentage(p).

:- area(A), percentage(P),
   C = #count{ CX,CY : cell(CX,CY) },
   C != (P * A) / 100.

% x coordinates
coord_x(1..W) :- width(W).

% y coordinates
coord_y(1..H) :- height(H).

% A cell belongs to the shape or not.
0 { cell(CX,CY) } 1 :- coord_x(CX), coord_y(CY).

% The cell (1,1) always belongs to the shape
% because the starting point is (0,0).
cell(1,1).

% Each cell is connected to each other by
% a path of 0 or more cells in between.
path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2), path(CX1,CY1,CX2 - 1,CY2).

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2), path(CX1,CY1,CX2 + 1,CY2).

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2), path(CX1,CY1,CX2,CY2 - 1).

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2), path(CX1,CY1,CX2,CY2 + 1).

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2),
                         CX1 == CX2 - 1, CY1 == CY2.

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2),
                         CX1 == CX2 + 1, CY1 == CY2.

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2),
                         CX1 == CX2, CY1 == CY2 - 1.

path(CX1,CY1,CX2,CY2) :- cell(CX1,CY1), cell(CX2,CY2),
                         CX1 == CX2, CY1 == CY2 + 1.

path(CX1,CY1,CX1,CY1) :- cell(CX1,CY1).

:- cell(CX1,CY1), cell(CX2,CY2), not path(CX1,CY1,CX2,CY2).

% At least one cell of the last column (W-th column) belongs to the shape
:- C = #count{ CX,CY : cell(CX,CY), width(W), CX == W },
   C == 0.

% At least one cell of the last row (H-th row) belongs to the shape
:- C = #count{ CX,CY : cell(CX,CY), height(H), CY == H },
   C == 0.

% If two cells belonging to the shape touch each other,
% they can not do it with only one vertex.
:- cell(CX,CY), cell(CX + 1,CY + 1),
   not cell(CX,CY + 1), not cell(CX + 1,CY).

:- cell(CX,CY), cell(CX + 1,CY - 1),
   not cell(CX + 1,CY), not cell(CX,CY - 1).

:- cell(CX,CY), cell(CX - 1,CY - 1),
   not cell(CX - 1,CY), not cell(CX,CY - 1).

:- cell(CX,CY), cell(CX - 1,CY + 1),
   not cell(CX - 1,CY), not cell(CX,CY + 1).

% There can not be holes in the shape.
n_cell(CX,CY) :- coord_x(CX), coord_y(CY), not cell(CX,CY).

free(CX,CY) :- n_cell(CX,CY), CX == 1.

free(CX,CY) :- width(W), n_cell(CX,CY), CX == W.

free(CX,CY) :- n_cell(CX,CY), CY == 1.

free(CX,CY) :- height(H), n_cell(CX,CY), CY == H.

free(CX,CY) :- n_cell(CX,CY), free(CX - 1,CY).

free(CX,CY) :- n_cell(CX,CY), free(CX + 1,CY).

free(CX,CY) :- n_cell(CX,CY), free(CX,CY - 1).

free(CX,CY) :- n_cell(CX,CY), free(CX,CY + 1).

:- n_cell(CX,CY), not free(CX,CY).


% Retrieve the points that characterize the figure.
% 1st case: a single cell (area = 1)
point(CX,CY) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX - 1,CY) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX - 1,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).

% 2nd case: a cell adjacent to only one cell
point(CX - 1,CY) :- cell(CX,CY), not cell(CX - 1,CY), cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX - 1,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).

point(CX,CY) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX - 1,CY) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), cell(CX,CY - 1), not cell(CX,CY + 1).

point(CX,CY) :- cell(CX,CY), cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).
point(CX,CY - 1) :- cell(CX,CY), cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), not cell(CX,CY + 1).

point(CX,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), cell(CX,CY + 1).
point(CX - 1,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), cell(CX,CY + 1).

% 3rd case: a cell adjacent to two other cells
% - one on the left or the right
% - one on the top or the bottom
point(CX - 1,CY - 1) :- cell(CX,CY), not cell(CX - 1,CY), cell(CX + 1,CY), not cell(CX,CY - 1), cell(CX,CY + 1).

point(CX - 1,CY) :- cell(CX,CY), not cell(CX - 1,CY), cell(CX + 1,CY), cell(CX,CY - 1), not cell(CX,CY + 1).

point(CX,CY) :- cell(CX,CY), cell(CX - 1,CY), not cell(CX + 1,CY), cell(CX,CY - 1), not cell(CX,CY + 1).

point(CX,CY - 1) :- cell(CX,CY), cell(CX - 1,CY), not cell(CX + 1,CY), not cell(CX,CY - 1), cell(CX,CY + 1).

% 4th case: a cell adjacent to two other cells to form an "L"
point(CX,CY) :- cell(CX,CY), cell(CX + 1,CY), cell(CX,CY + 1), not cell(CX + 1,CY + 1).

point(CX,CY - 1) :- cell(CX,CY), cell(CX + 1,CY), cell(CX,CY - 1), not cell(CX + 1,CY - 1).

point(CX - 1,CY - 1) :- cell(CX,CY), cell(CX - 1,CY), cell(CX,CY - 1), not cell(CX - 1,CY - 1).

point(CX - 1,CY) :- cell(CX,CY), cell(CX - 1,CY), cell(CX,CY + 1), not cell(CX - 1,CY + 1).


%#show cell/2.
#show point/2.
#show percentage/1.