note
	description: "Objects for computing distances to elements of a file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMINER

create
	make

feature
	make (f: STRING_32; m: INTEGER)
			-- Initialize for word file named `f' and max distance `m'.
		local
			line: STRING_32
			words_of_dist: ARRAYED_LIST [STRING_32]
		do
			max := m
			create word_file.make_open_read (f)
			create word_list.make (0)
			from word_file.start until word_file.after loop
				word_file.read_line
				line := word_file.last_string
				line.to_lower
				if not line.is_empty then
					word_list.extend (line)
				end
			end
			across 0 |..| max as i from create neighbors.make_empty loop
				create words_of_dist.make (0)
				neighbors.force_and_fill (words_of_dist, i.item)
			end
		end

feature -- Status report

	computed: BOOLEAN
			-- Have we computed the distances?


feature -- Access


	max: INTEGER
			-- Maximum distance considered for closes matches.

	word_file: PLAIN_TEXT_FILE
			-- File containing words to match.



feature -- Basic operations

	compute (candidate: STRING_32)
			-- Find out closest matches for `candidate'
		local
			l: LEVENSHTEIN
			d: INTEGER			-- Computed distance
			tested: STRING_32
		do
			across word_list as w loop
				tested := w.item
--				print ("Processing " + tested.out + "%N")
				create l.make (candidate, tested)
				l.compute
				d  := l.distance
--				print ("++ Distance of " + candidate +  " to " + tested + " is " + d.out + "%N")
				if d <= max then
					neighbors [d].extend (tested)
				end
			end
			computed := True
		ensure
			computed: computed
		end

feature -- Input-output

	matches: STRING_32
			-- List of closest matches (of last examined word) in word list.
			-- Ordered by distance; on each line, neighbors with same distance.
		require
				computed: computed
		do
			Result := ""
			across neighbors as l loop
				if not l.item.is_empty then
					Result := Result + (l.cursor_index - 1).out + ": "
					across l.item as w loop
						if l.cursor_index > 1 then Result := Result + " " end
						Result := Result + w.item
					end
					Result := Result + "%N"
				end
			end
		end

feature -- Implementation

	word_list: ARRAYED_LIST [STRING_32]
			-- Words to match.

	neighbors: ARRAY [ARRAYED_LIST [STRING_32]]
			-- At index `i', words from `word_list' having distance `i' to word being matched.

end
