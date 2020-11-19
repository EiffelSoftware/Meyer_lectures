class
	LEVENSHTEIN


create
	make

feature -- Initialization

	make (s, t: STRING_32)
			-- Set up problem with source and target given by `s' and `t'.
		do
			source := s
			target := t
			scount := source.count ; tcount := target.count
			create distances.make_filled (0, scount, tcount)
			create operations.make_filled ('%U', scount, tcount)
			create trace.make
		end


feature -- Access

	source, target: STRING_32
			-- Parameters of the problem

	scount, tcount: INTEGER
			-- Size of source and target


	trace: LINKED_LIST [OPERATION]
			-- Sequential list of operations to be
			-- applied (computed by Levenshtein algorithm)
			-- Each triple is:
			--		Reference position in source string, if any
			--		Reference position in target string, if any
			--		Operation (K, S, I or D)

	distances: ARRAY_2 [INTEGER]
			-- Table of distances (computed by Levenshtein algorithm)

	operations: ARRAY_2 [CHARACTER]
			-- Table of operations (computed by Levenshtein algorithm)


feature -- Status report

	solved: BOOLEAN
			-- Has problem instance been solved?

	reconstructed: BOOLEAN
			-- Has transformation structure been produced?

feature -- Basic operations

	solve
			-- Compute distance between `source'  and `target' and print out results.
		do

			compute
			reconstruct
			explain
		end


	compute
			-- Fill in arrays.
		local
			i, j: INTEGER
			deletion, insertion, substitution: INTEGER
			value, minimum: INTEGER
			op: CHARACTER
		do

 			from i := 0	until i > scount loop distances [i, 0] := i ; operations [i, 0] := 'D' ; i := i + 1 end
 			from j := 0	until j > tcount loop distances [0, j] := j ; operations [0, j] := 'I' ; j := j + 1 end
 			operations [0, 0] := 'K'

 			from i := 1	until i > scount loop
 				from j := 1	until j > tcount loop
 					if source [i] = target [j] then
 						value := distances [i-1, j-1]
						op := 'K'
					else
 						deletion := distances [i-1, j]
 						insertion := distances [i, j-1]
 						substitution := distances [i-1, j-1]
 						minimum := deletion.min (insertion.min (substitution))
 	 					if minimum = deletion then
 							op := 'D'
 						elseif minimum = insertion then
 							op := 'I'
 						elseif minimum = substitution then
 							op := 'S'
		 				end
		 				value := minimum + 1
 					end
 				 	distances [i, j] := value
 				 	operations [i, j] := op
 					j := j + 1
 				end
 				i := i + 1
 			end
 			solved := True
 		ensure
 			done: solved
 		end

 	reconstruct
 			-- Through the array of operations, produce sequence
 			-- of transformations from `source' to `target'.
 		require
 			done: solved
 		local
 			op: CHARACTER
 			i, j, n: INTEGER
 			new: STRING_32
 			step: OPERATION
 			first, rest: STRING_32
 		do
 			from
 				new := target.twin

 				i := scount; j := tcount
 				n := tcount
 			until
 				i = 0 and j = 0
 			loop
 				op := operations [i, j]
 				create step.make (i, j, op)
 				step.set_transformed (new)
 				trace.put_right (step)
 				first := new.substring (1, n-1) ; rest := new.substring (n + 1, new.count)
 				check op = 'K' or op = 'S' or op = 'D' or op = 'I' end
				inspect
					op
				when 'K' then
						check
							source [i] = target [j]
								-- We keep the element, so it'd better be the same!
						end
 					i := i - 1 ; j := j - 1
 					n := n - 1
 				when 'S' then
 						check
							source [i] /= target [j]
								-- We should not do a substitution if the
								-- elements were already the same
						end
					new := first + source.substring (i, i) + rest
					n := n - 1
 					i := i - 1 ; j := j -1
 				when'D' then
 					new := first + new.substring (n, n) + source.substring (i, i) + rest
 					i := i - 1
 				when 'I' then
 					new := first + rest
 					n := n - 1
 					j := j - 1
 				end
			variant
 				i+ j
			end
			reconstructed := True
		ensure
			reconstructed: reconstructed
 		end

 	explain
 				-- Display, in an human-readable form, the list of transformations
 				-- leading from source to target.
 			require
 				done: reconstructed
 			local
 				t: OPERATION
 				i, j, n: INTEGER
 				op: CHARACTER
 				new,first, rest: STRING_32
 				dist: INTEGER
 			do
 				new := source.twin
 				from
			 		trace.start
			 		n := 1
				until
			 		trace.after
				loop

				 	t := trace.item
				 	i := t.i ; j := t.j ; op := t.code
				 	first := new.substring (1, n-1) ; rest := new.substring (n + 1, new.count)
			 		inspect
			 			op
			 		when 'S' then
			 			new := first + target.substring (j, j) + rest
			 			n := n + 1
			 			dist := dist + 1
			 		when 'D' then
			 			new := first + rest
			 			dist := dist + 1
			 		when 'I' then
			 			new := first + target.substring (j, j) + new.substring (n, n) + rest
			 			n := n + 1
			 			dist := dist + 1
			 		when 'K' then
			 			n := n + 1
			 		end
			 		io.put_string ("[" + i.out + "," + j.out + "]%T" + op.out + "%T")
			 		print (dist) ; print ("%T")
			 		print (new)
--			 		print (" * ") ; print (t.transformed)
				 	io.put_new_line
				 	trace.forth
				end
 			end

	distance: INTEGER
 				-- Levenshtein distance between `source' and `target'
 			require
 				done: solved
 			do
 				Result := distances [scount, tcount]
 			end


feature -- Input and output


invariant

	source_exists: source /= Void
	target_exists: target /= Void
	consistent: reconstructed implies solved
end
