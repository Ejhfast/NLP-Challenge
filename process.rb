# takes three arguments, the names of the vocab file, document file, and output file

def parse_vocab vocab, docs, out
	count = 0
	fh = Hash.new
	f = File.open(vocab, "r")
	f.each_line{ |line|
		pair = line.split.map{|x| x.chomp}
		word = pair[1]
		freq = 1.0 / pair[0].to_f
		fh[word] = freq
	}
	f.close
	ans = word_freq docs, fh
	fo = File.open(out,"w")
	ans.keys.each do |word|
		tmp = ans[word].keys.sort_by{|x| -1 * ans[word][x]}.select{|x| x != word}
		if tmp.size >= 10
			fo.puts word + " " + tmp.first(10).join(" ")
		else
			# not ten relations? ...
			# look through more tenuous connections
			rest = 10 - tmp.size
			fo.puts word + " " + tmp.join(" ") + " " + tmp.first(2).map{|x| ans[x].keys.sort_by{|y| -1 * ans[x][y]}}.flatten.uniq.select{|x| not tmp.include?(x)}.first(rest).join(" ")
		end	
	end
	fo.close
end


def word_freq the_file, freq_hash
	# get word cooccurence information
	h = Hash.new(nil)
	count = 0
	f = File.open(the_file, "r")
	f.each_line { |line|
  	puts count
		words = line.split.map{|x| x.chomp}
  	words.each { |w|
			words.each {|w2|
				if not h[w].nil?
					h[w][w2] = h[w][w2] + (1.0 * freq_hash[w2].to_f)
				else
					h[w] = Hash.new(0.0)
					h[w][w2] = (1.0 * freq_hash[w2].to_f)
				end
			}
		}
	count = count + 1
	}
	f.close
	return h
end


parse_vocab ARGV[0], ARGV[1], ARGV[2]
