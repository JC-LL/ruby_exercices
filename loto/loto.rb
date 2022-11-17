
def generate
  (1..49).to_a.sample(6)
end

def find_nb_correct_numbers tirage,grille
  sum=tirage+grille
  sum.size-sum.uniq.size
end

nb_trials=(ARGV.first||1000).to_i

GAINS={
  3 => 10,
  4 => 1000,
  5 => 100000,
  6 => 1000000
}

bank=0
sem=0
nb_trials.times do |id|
  sem+=1 if id.even?
  bank-=2
  tirage=generate
  grille=generate
  nb_correct_numbers=find_nb_correct_numbers(tirage,grille)
  bank+= GAINS[nb_correct_numbers] || 0
  hit="!"*nb_correct_numbers if nb_correct_numbers > 3
  print "semaine #{sem.to_s.ljust(3)} tirage #{id.to_s.ljust(9)}:"
  print "#{tirage.sort.join(',').ljust(20)} grille : #{grille.sort.join(',').ljust(20)}"

  puts "#correct numbers=#{nb_correct_numbers} bank=#{bank} #{hit}"
end
