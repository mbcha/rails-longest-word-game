require 'open-uri'

class GamesController < ApplicationController
def new
	@letters = []
	(0...10).map { @letters << ('a'..'z').to_a[rand(26)] }
end

def score
	@word = params[:word]
	@grid = params[:grid]
	@score = check_word
end

private

def check_word
	url = "https://wagon-dictionary.herokuapp.com/#{@word}"
	result = JSON.parse(open(url).read)

	grid = @grid.split(' ')
	word = @word.split('')  
	word_in_grid = word.all? { |letter| word.count(letter) <= grid.count(letter) }

	get_result(word_in_grid, result['found'], result['length'], {})
end

def get_result(word_in_grid, match_found, word_length, result)
  if !word_in_grid
    result[:message] = 'The word is not in the grid'
    result[:score] = 0
  elsif match_found
    result[:message] = 'Well Done!'
    result[:score] = word_length * 2
    add_to_total(result[:score])
  else
    result[:message] = 'This is not an english word'
    result[:score] = 0
  end

  result
end

	def add_to_total(score)
		if session[:cumulative_score].nil?
			session[:cumulative_score] = score
		else
    session[:cumulative_score] = session[:cumulative_score] + score
			
		end
	end
end
