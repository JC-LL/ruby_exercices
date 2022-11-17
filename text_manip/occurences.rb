text=IO.read(ARGV.first).downcase!
words=text.scan(/[[:alpha:]]+/) # /\w+/ does not match accents
occurences=words.tally
paires=occurences.sort_by{|word,occurence| occurence}
paires.reverse[0...10].each{|paire| p paire}
