require 'open-uri'

# games
class GamesController < ApplicationController
  attr_reader :letters, :words

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    words = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{words}"
    user_serialized = URI.open(url).read
    data = JSON.parse(user_serialized)
    # raise
    if data['found'] && check_word(words, @letters)
      @results = "Congratulations! #{words.capitalize} is a valid English word!"
    elsif check_word(words, @letters) == false
      @results = "Sorry but #{words.capitalize} can't be build out of #{@letters}"
    else
      @results = 'Not an english word!'
    end
  end

  def check_word(attempt, grid)
    attempt_to_char = attempt.upcase.chars
    check = true
    attempt_to_char.each do |letter|
      # raise
      check = false unless grid.include?(letter)
      check = false unless attempt_to_char.count(letter) <= grid.count(letter)
    end
    return check
  end
end
