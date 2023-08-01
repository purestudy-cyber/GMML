function [row_range, col_range] = get_neighbor(index, rows, lines, window)
row = mod(index,rows);
if row == 0
    row = rows;
end
col = ceil(index/rows);
row_range = row-(window-1)/2 : row+(window-1)/2;
row_range(row_range<=0) = 1;
row_range(row_range>=rows) = rows;
col_range = col-(window-1)/2 : col+(window-1)/2;
col_range(col_range<=0) = 1;
col_range(col_range>=lines) = lines;
end