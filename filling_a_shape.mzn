% Problem: Filling a shape
%
% Consider a figure whose outer edges are defined by a sequence of points (e.g., (0,0),(0,2),(2,2),(2,5),(4,5),(4,1),(2,1),(2,0)).
% You have as many as you need "L" pieces (the biggest border is of size 2) plus unitary "U" pieces. "L" pieces can rotate (in the
% same plane, they cannot be turned upside down - "U" pieces can rotate as well, but it doesn't matter too much).
% The goal is to fill the internal shape of the figure, without overlapping the pieces minimizing the overall number of pieces used.
%
% By Michele Collevati

% Parameters
int: num_points;  % number of points
array[1..num_points,1..2] of int: seq_points; % sequence of points
int: width = max([seq_points[p,1] | p in 1..num_points]);  % width of the input points bounding box
int: height = max([seq_points[p,2] | p in 1..num_points]); % height of the input points bounding box
int: num_cells = width * height;  % number of cells (area of the bounding box)
set of int: cells = 1..num_cells;
int: L_size = 3;  % size in cells of a L-piece
set of int: piece_components = 1..L_size;
int: digs = ceil(log(10.0,num_cells));  % digits for output

% Decision variables
array[cells,piece_components] of var 0..num_cells: pieces;
var 0..num_cells: num_U_pieces;   % number of "U" pieces
var 0..floor(num_cells div L_size): num_L_pieces;  % number of "L" pieces

% Constraints

% Cells that do NOT belong to the shape must be equal to 0.
% Cells that belong to the shape must be different from 0.
% Let C be a cell.
% Let N be the number of points having x and y coordinates lower than C's coordinates.
% IF N is even THEN C does NOT belong to the shape
% ELSE (N is odd) C belongs to the shape
constraint
  forall(y in 1..height,x in 1..width)
    (if (length([p | p in 1..num_points where seq_points[p,1] < x /\ seq_points[p,2] < y]) mod 2) = 0
     then forall(pc in piece_components)
            (pieces[(y-1)*width+x,pc] = 0)
     else forall(pc in piece_components)
            (pieces[(y-1)*width+x,pc] != 0)
     endif);

% Or all piece_components of a cell c are = 0 (the cell c does NOT belong to the shape)
% or all piece_components of a cell c are = c ("U" piece)
% or exactly one piece_component of a cell c is = c ("L" piece).
% To prevent a cell from having piece_components of a
% "L" piece it does NOT belong to: each cell belonging
% to a "L" piece must have a piece_component equal to
% its index.
constraint
  forall(c in cells)
    (forall(pc in piece_components) (pieces[c,pc] = 0) \/
     forall(pc in piece_components) (pieces[c,pc] = c) \/
     sum(pc in piece_components) (pieces[c,pc] = c) = 1);

% To form "L" pieces: the index of the cell in the middle of the piece
% is 1 and W respectively distant from the index of the other two cells.
% Symmetry breaker:
% pieces[c,1] is the cell in the middle of the piece
% pieces[c,2] is the cell distant 1 from the cell in the middle of the piece
% pieces[c,3] is the cell distant width from the cell in the middle of the piece
constraint
  forall(c in cells)
    (sum(pc in piece_components) (pieces[c,pc] = c) = 1 ->
      abs(pieces[c,1] - pieces[c,2]) = 1 /\ abs(pieces[c,1] - pieces[c,3]) = width);

% To prevent non-legal "L" pieces: a cell with multiple index
% of the width can NOT form a "L" piece with the next cell,
% because they are NOT adjacent in the bounding box.
constraint
  forall(c in cells)
    (if (c mod width) = 0
     then sum(pc in piece_components) (pieces[c,pc] = c) = 1 ->
             not exists(pc in piece_components) (pieces[c,pc] = c+1)
     else if (c mod width) = 1
          then sum(pc in piece_components) (pieces[c,pc] = c) = 1 ->
                  not exists(pc in piece_components) (pieces[c,pc] = c-1)
          else true
          endif
     endif);

% To tie together the 3 cells that form a "L" piece:
% they must have the same piece_components.
constraint
  forall(c in cells)
    (sum(pc in piece_components) (pieces[c,pc] = c) = 1 ->
       forall(pcI in piece_components,pcJ in piece_components)
         (pieces[c,pcI] = pieces[pieces[c,pcJ],pcI]));

% number of "U" pieces
constraint
  num_U_pieces = sum(c in cells)
                    (forall(pc in piece_components) (pieces[c,pc] = c));

% number of "L" pieces
constraint
  num_L_pieces = sum(c in cells)
                    (sum(pc in piece_components) (pieces[c,pc] = c) = 1) div L_size;

% Solve
solve :: int_search(pieces, input_order, indomain_max, complete) minimize num_U_pieces;
%solve :: int_search(pieces, first_fail, indomain_max, complete) minimize num_U_pieces;

% Output
output
[
  if x = 1 then "\n" else " " endif ++
    if fix(pieces[(height-y)*width+x,1]) = 0
    then format_justify_string(digs,"*")
    else show_int(digs,pieces[(height-y)*width+x,1])
    endif
  | y in 1..height,x in 1..width
]
++ ["\n\n"] ++
[
  "Number of \"L\" pieces = ", show(num_L_pieces), "\n",
  "Number of \"U\" pieces = ", show(num_U_pieces), "\n"
];