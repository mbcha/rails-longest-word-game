require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    (0...10).map { @letters << ('a'..'z').to_a[rand(26)] }
    @time = Time.now
  end

  def score
    @word = params[:word]
    @start_time = params[:start_time]
    @grid = params[:grid]
    @score = check_word
  end

  private

  def check_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user = JSON.parse(open(url).read)

    result = { time: Time.now - @start_time.to_i, score: 0 }

    letter_in_grid = compare_letters

    get_result(letter_in_grid, user['found'], user['length'], result)
  end

  def compare_letters
    letter_in_grid = ''

    grid = @grid.split(' ')

    @word.split('').each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        letter_in_grid += 'N'
      end
    end

    letter_in_grid
  end

  def get_result(letter_in_grid, user_word, user_word_length, result)
    if letter_in_grid.include? 'N'
      result[:message] = 'The word is not in the grid'
    elsif user_word
      result[:message] = 'Well Done!'
      result[:time] < 5 ? result[:score] = user_word_length + 1 : result[:score] = user_word_length
    else
      result[:message] = 'This is not an english word'
    end

    result
  end
end
