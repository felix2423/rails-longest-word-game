require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = generate_grid
  end

  def score
    @word = params[:word]
    @letters = params[:grid]
    @dictionary_data = check_dictionary
    @included = check_grid
    @message = compute_message
  end

  private

  def generate_grid
    grid = []
    alphabet = ('A'..'Z').to_a
    10.times { grid << alphabet.sample }
    grid
  end

  def check_dictionary
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    JSON.parse(URI.open(url).read)
  end

  def check_grid
    word_letters = @word.upcase.chars
    word_letters.all? do |letter|
      @letters.include?(letter) && word_letters.count(letter) <= @letters.count(letter)
    end
  end

  def compute_message
    if @dictionary_data['found'] == false
      "Sorry but '#{@word}' does not seem to be a valid English word..."
    elsif @included == false
      "Sorry but '#{@word}' can't be built out of #{@letters}"
    else
      "Congratulations! You scored #{(@dictionary_data['length'] * 2)**2}."
    end
  end
end
