require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

# inspritation from: http://www.peteonsoftware.com/index.php/2009/08/17/the-greed-ruby-koan/

def score(dice)
  tally = 0

  dice_sort = {1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0}
  
  dice.each do |die|
    dice_sort[die] += 1    #  key technique 
  end
  
  dice_sort.each_pair do |die, count|
    if count > 3
      while count > 3   # runs through again if the count is higher than three
        tally += tally_up(die, [count, 3].min)    # either go with 3 or the count
        count -= 3
      end
      tally += tally_up(die, count)      
    else
      tally += tally_up(die, count)
    end
  end
  
  return tally if valid_dice?(dice)
end

def valid_dice?(dice)
  return true if (dice.count>0 or dice.count<6)
end

def tally_up(die, count)
  tally = 0
  
  #  SCORES
  three_ones = 1000
  three_otherwise_multiplier = 100
  each_one = 100
  each_five = 50
  
  if count < 3
    case die
    when 1 then tally += each_one*count
    when 5 then tally += each_five*count
    end
  elsif count == 3
    case die
    when 1 then tally += three_ones
    else tally += die*three_otherwise_multiplier
    end
  end
  
  return tally
end

#--------TESTS-----------------------------

class AboutScoringProject < EdgeCase::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
  end

end
