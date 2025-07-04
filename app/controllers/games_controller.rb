class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    vowels = %w[A I U E O Y]
    alphabet = ('A'..'Z').to_a
    @grid = [vowels.sample]
    9.times do
      @grid << alphabet.sample
    end
    @grid_join = @grid.join('')
  end

  def score
    @score = 0
    @word = params[:word].upcase
    @grid = params[:grid].chars
    @letters = @word.chars
    is_valid = validate_word(@letters, @grid)
    @response = build_response(@word, @grid, is_valid)
    @score += @word.length if @response.start_with?("Congratulations!")
  end

  private

  def validate_word(letters, grid)
    letters.all? do |letter|
      grid.include?(letter) && letters.count(letter) <= grid.count(letter)
    end
  end

  def validate_meaning(word)
    result_content = JSON.parse(URI.parse("https://dictionary.lewagon.com/#{word}").read)
    if result_content["found"] == true
      "Congratulations! #{word} is a valid English word!"
    else
      "Sorry! #{word} does not seem to be a valid English word..."
    end
  end

  def build_response(word, grid, validation)
    return "Sorry but #{word} can't be built out of #{grid.join(', ')}" if validation == false

    validate_meaning(word) if validation == true
  end
end
