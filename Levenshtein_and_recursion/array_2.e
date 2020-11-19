class
	ARRAY_2 [G]

inherit
	ARRAY2 [G]
		rename
			item as old_item, put as old_put
		redefine
			make_filled
		end
create
	make_filled

feature -- Initialization
	make_filled (defval: G; rows, columns: INTEGER)
			--
		do
			row_max := rows
			column_max := columns
			Precursor (defval, rows + 1, columns + 1)
		end


feature -- Access

	row_max: INTEGER
			-- Maximum allowed row index


	column_max: INTEGER
			-- Maximum allowed column index

	item alias "[]" (i, j: INTEGER): G assign put
			-- Element at row `i', column `j'
		require
			row_large_enough: i >= 0
			row_small_enough: i <= row_max
			column_large_enough: j >= 0
			column_small_enough: j <= column_max
		do
			Result := old_item (i+1, j+1)
		end

	put (x: G; i, j: INTEGER)
			-- Set to x the value of the item at
			-- row `i', column `j'.
		require
			row_large_enough: i >= 0
			row_small_enough: i <= row_max
			column_large_enough: j >= 0
			column_small_enough: j <= column_max
		do
			old_put (x, i+1, j+1)
		end


invariant
	one_more_row: height = row_max + 1
	one_more_column: width = column_max + 1
end
