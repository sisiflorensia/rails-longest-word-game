require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << [*('A'..'Z')].sample() }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @result = ''
    word_arr = @word.upcase!.split('')

    url = 'https://wagon-dictionary.herokuapp.com/' + @word
    check_english = JSON.parse(open(url).read)

    incl_check = word_arr.all? { |char| @letters.include?(char) ? true : false }
    count_grid = {}
    @letters.split('').each { |letter| count_grid.key?(letter) ? count_grid[letter] += 1 : count_grid[letter] = 1 }
    count_word = {}
    word_arr.each { |char| count_word.key?(char) ? count_word[char] += 1 : count_word[char] = 1 }

    if check_english['found'] == false
      @result = "Sorry, but #{@word} doesn't seem to be a valid English word."
    elsif incl_check == false
      @result = "Sorry, but #{@word} can't be built out of existing letters."
    elsif count_word.all? { |k, v| v <= count_grid[k] } == false
      @result =  "Sorry, but #{@word} can't be built out of existing letters."
    else
      @result = "Congratulations! #{@word} seems to be a valid English word."
    end

    @result
  end
end
