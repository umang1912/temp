$non_scoring = 0
$player_scores = [0,0]
$current_round_score = 0


def get_dice(num)
  num = 5 if num == 0
  dice = Array.new
  (0..num-1).each {|i| dice[i] = 1 + rand(6)}
  dice
end

def score(dice)
  $non_scoring = 0
  score = 0
  hash = Hash.new(0)
  dice.each do |x|
    hash[x] += 1
  end
  (1..6).each do |x|
    if hash[x] >= 3
      if x == 1
        score += 1000
      else
        score += x*100
      end
      hash[x] %= 3
    elsif dice.include?(x) && ![1,5].include?(x)
      $non_scoring += hash[x]
    end

    if x == 1
      score += hash[x]*100
    elsif x == 5
      score += hash[x]*50
    end
  end
  puts "non scoring - " + $non_scoring.to_s
  score
end

puts "GREED"

def play(player)
  loop do
    puts "Player #{player} ready to roll? (y/n)"
    play = gets
    if play.match(/y/)
      dice = get_dice($non_scoring)
      puts "Player #{player} rolled - " + dice.inspect
      score = score(dice)
      puts score
      $current_round_score += score if (score > 300 || $player_scores[player-1] > 0)
      
      if score == 0
        $current_round_score = 0
        break
      end
      puts "your current score - " + $current_round_score.inspect
    else
      break
    end
  end
  $player_scores[player-1] += $current_round_score
  $current_round_score = 0

  puts "your net score - " + $player_scores[player-1].inspect
  $non_scoring = 0 # for next time
  $player_scores[player-1]
end


while ($player_scores[0] < 3000 && $player_scores[1] < 3000)
  play(1)
  play(2)
  puts "score1 - " + $player_scores[0].inspect
  puts "score2 - " + $player_scores[1].inspect
end

puts "FINAL ROUND"
play(1)
play(2)
puts "score1 - " + $player_scores[0].inspect
puts "score2 - " + $player_scores[1].inspect
puts ($player_scores[0] > $player_scores[1] ? "Player 1 wins!" : "Player 2 wins!") 
