class
	OPERATION
create
	make

feature -- Access
	make (a, b: INTEGER; op: CHARACTER)
				-- Set to represent operation corresponding to
				-- positions `a' in source and `b' in target,
				-- operation code `op', and empty transformed value.
			require
				valid_source_position: a >= 0
				valid_target_position: b >= 0
				valid_code: (op = 'D') or (op = 'I') or (op = 'K') or (op = 'S')
			do
			 	i := a ; j := b ; code := op; transformed := ""
			end


feature -- Access

	i: INTEGER
		-- Position in source string

	j: INTEGER
		-- Position in target string

	code: CHARACTER
		-- Code for operation:
		--		 'D' for Delete	
		--		 'I' for Insert
		--		 'K' for Keep
		--		 'S' for Substitute

	transformed: STRING
		-- Value at this stage of the transformation

feature -- Element change

	set_transformed (t: STRING)
			-- Set `transformed' to `t'.
		require
			valid_value: t /= Void
		do
			transformed := t
		end


invariant

	valid_code: (code = 'D') or (code = 'I') or (code = 'K') or (code = 'S')
	valid_source_position: i >= 0
	valid_target_position: j >= 0
--	valid_value: transformed /= Void

end
