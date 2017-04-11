require 'sinatra'
require 'sinatra/reloader'
require 'JSON'

configure do
  enable :sessions
   set :session_secret, "p1nkfluffyun1cornsdanc1ngonra1nbows"
end

get '/' do
  erb :default
end


post '/guess' do
  guesses = params['guess_count'].to_i
  correct = params['correct_number'].to_i
  guess = params['guess']
  case
  when guess.to_i == correct
    { message: "Yay! You guessed the number!", done: "Finished"}.to_json
  when guesses >= 9
    { message: "oh noooooooos. You ran out of guesses!", done: "Finished"}.to_json
    when !is_a_number?(guess)
      guesses += 1
      { message: "#{guess} isn't an integer, dummy!", guess_count: guesses}.to_json
    when guess.to_i > correct
      guesses += 1
      { message: "#{guess} is too high! Guess again!", guess_count: guesses}.to_json
    when guess.to_i < correct
      guesses += 1
      { message: "#{guess} is too low! Guess again!", guess_count: guesses}.to_json
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
