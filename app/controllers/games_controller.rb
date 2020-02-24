require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  ALPHABETS = ('A'..'Z').to_a

  def new
    @letters = []
    5.times { @letters << VOWELS.sample }
    5.times { @letters << (ALPHABETS - VOWELS).sample }
    @letters.shuffle!

    score
  end

  private

  def score
    @response = params[:letters]
    @letters = @response.chars unless @response.blank?
    @answer = (params[:answer] || '').upcase.chars
    @score = nil

    if invalid_word_count?(@letters, @answer)
      @score = "You can\'t build #{@answer.join('')} from #{@letters.join}"
    elsif english_word?(@answer.join(''))
      @score = @answer.count
    else
      @score = "#{@answer.join('')} is not an English word"
    end
  end

  def invalid_word_count?(grid, ans)
    l_dic = {}
    grid.each { |char| l_dic[char] ? l_dic[char] += 1 : l_dic[char] = 1 }
    a_dic = {}
    ans.each { |char| a_dic[char] ? a_dic[char] += 1 : a_dic[char] = 1 }

    check_array = []
    a_dic.each do |k, v|
      if l_dic[k].nil?
        check_array << false
      else
        l_dic[k] < v ? check_array << false : check_array << true
      end
    end
    check_array.include? false
  end

  # def included?(word, letters)
  #   word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  # end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
