# takes two arguments, the name of the vocab file and the name of the document file

def parse_vocab vocab, docs, out
	count = 0
	fh = Hash.new
	f = File.open(vocab, "r")
	f.each_line{ |line|
		pair = line.split
		word = pair[1]
		freq = 1.0 / pair[0].to_f
		fh[word] = freq
	}
	f.close
	ans = word_freq docs, fh
	fo = File.open(out,"w")
	ans.keys.each do |word|
		fo.print "#{word}"
		ans[word].each {|w| fo.print " #{w[0]}"}
		fo.print "\n"
	end
end


def word_freq the_file, freq_hash
	# get word frequencies from file, excluding the original word 
	h = Hash.new(nil)
	hbest = Hash.new
	count = 0
	f = File.open(the_file, "r")
	f.each_line { |line|
  	puts count
		words = line.split
  	words.each { |w|
			words.each {|w2|
				if not h[w].nil?
						if not h[w][w2].nil?
							h[w][w2] = h[w][w2] + (1.0 * freq_hash[w2].to_f)
						else
							h[w][w2] = (1.0 * freq_hash[w2].to_f)
						end
				else
					h[w] = Hash.new
					h[w][w2] = (1.0 * freq_hash[w2].to_f)
				end
				if not hbest[w].nil?
					if h[w][w2] > hbest[w].last[1] && w != w2
						hbest[w][9] = [w2,h[w][w2]]
						hbest[w] = hbest[w].sort_by{|x| -x[1]}	
					end
				else
					hbest[w] = [["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],["-.-",0],]
				end
			}
		}
	count = count + 1
	}
	f.close
	return hbest
end


parse_vocab ARGV[0], ARGV[1], ARGV[2]
