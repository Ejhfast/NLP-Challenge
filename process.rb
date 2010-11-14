# takes two arguments, the name of the vocab file and the name of the document file

def parse_vocab vocab, docs
	count = 0
	f = File.open(vocab, "r")
	f.each_line{ |line|
		pair = line.split
		word = pair[1]
		freq = pair[0].to_i
		`grep '#{word}' #{docs} > wordfiles/word#{count}`
		answer = word_freq("wordfiles/word#{count}", word)
		answer.keys.each do |k|
			answer[k] = answer[k].to_f / freq.to_f
		end
		adjusted_answer = top_ten(answer, word)
		puts adjusted_answer
		count = count + 1
	}
end


def word_freq the_file, excluded
	# get word frequencies from file, excluding a word 
	h = Hash.new
	f = File.open(the_file, "r")
	f.each_line { |line|
  	words = line.split
  	words.each { |w|
			if w != excluded 
    		if h.has_key?(w)
      		h[w] = h[w] + 1
    		else
      		h[w] = 1
    		end
			end
  	}
	}
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
