# takes two arguments, the name of the vocab file and the name of the document file

def parse_vocab vocab, docs
	count = 0
	f = File.open(vocab, "r")
	f.each_line{ |line|
		pair = line.split
		word = pair[1]
		freq = pair[0].to_i
		puts "start grep"
		`grep '#{word}' #{docs} > wordfiles/word#{count}`
#		puts "start freq"
#		answer = word_freq("wordfiles/word#{count}", word)
#		puts "start adjust"
#		answer.keys.each do |k|
#			answer[k] = answer[k].to_f / freq.to_f
#		end
#		puts "start sort"
#		adjusted_answer = top_ten(answer, word)
#		puts adjusted_answer
#		count = count + 1
	}
	f.close
end


def word_freq the_file, excluded
	# get word frequencies from file, excluding the original word 
	h = Hash.new(0)
	f = File.open(the_file, "r")
	f.each_line { |line|
  	words = line.split
  	words.each { |w|
			if w != excluded 
					h[w] = h[w] + 1
			end
		}
	}
	f.close
	return h
end

# sort the hash by value, and then print it in this sorted order
def top_ten h, word
	str = word
	h.sort{|a,b| a[1]<=>b[1]}.last(10).reverse.each { |elem|
  	str = str + " #{elem[0]}"
	}
	return str
end

parse_vocab ARGV[0], ARGV[1]
