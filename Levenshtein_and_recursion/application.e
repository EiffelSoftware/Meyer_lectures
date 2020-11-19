note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature

	make
			-- Compute Levenshtein distance of two strings passed as execution parameters
		local
			l: LEVENSHTEIN
			s, t: STRING
			e: EXAMINER
		do
			if argument_count = 3 and then argument (1) ~ "DOYOUMEAN" then
				create e.make (argument (3), 2)
				e.compute (argument (2))
				print (e.matches)
			elseif argument_count /= 2 then
				print ("The Levenshtein distance calculator requires either one or exactly two strings as arguments%N")
			else
				s := argument (1)
				t := argument (2)
				create l.make (argument (1), argument (2))
				l.compute
				print ("Distance from " + s.out + " to " + t.out + ": " + l.distance.out + "%N%N")
				l.reconstruct
				l.explain
			end
		end



end
