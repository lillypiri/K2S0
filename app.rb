require 'sinatra'
require 'sinatra/reloader'
require 'JSON'

configure do
  enable :sessions
end

get '/' do
  erb :default
end


post '/guess' do
  # { guess: params['guess']}.to_json
  guesses = params['guess_count'].to_i
  case
  when params['guess'].to_i == params['correct_number'].to_i
      #change message to congratulations message
      # change button to 'new game' button
      # hide the input
      # change heading?
    { message: "Yay! You guessed the number!", done: "Finished"}.to_json
  when guesses >= 9
    { message: "oh noooooooos. You ran out of guesses!", done: "Finished"}.to_json
    when !is_a_number?(params['guess'])
      guesses += 1
      { message: "That's not an integer, dummy!", guess_count: guesses}.to_json
    when params['guess'].to_i > params['correct_number'].to_i
      guesses += 1
      { message: "Too high! Guess again!", guess_count: guesses}.to_json
    when params['guess'].to_i < params['correct_number'].to_i
      guesses += 1
      { message: "Too low! Guess again!", guess_count: guesses}.to_json
  end
end

post '/new_game' do
  session[:correct_number] = rand(100)
  session[:guess_count] = 0
  { correct_number: session[:correct_number], guess_count: session[:guess_count]}.to_json
end

def is_a_number? string
  string.to_i.to_s == string
end
