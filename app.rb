require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Evanston, Kellogg Global Hub... replace with a different location if you want
  @lat = 42.0574063
  @long = -87.6722787

  units = "imperial" # or metric, whatever you like
  key = "a5b32757a3a702c145b1d71d578fcaa1" # replace this with your real OpenWeather API key

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{@lat}&lon=#{@long}&units=#{units}&appid=#{key}"

  # make the call
  @forecast = HTTParty.get(url).parsed_response.to_hash

  #current forecast data
  @current = "It is currently #{@forecast["current"]["temp"]} degrees Farenheit and #{@forecast["current"]["weather"][0]["description"]}"

  #extended forecast data
  @extended = []
    for day in @forecast["daily"]
        @extended << "A high of #{day["temp"]["max"]} deg F and #{day["weather"][0]["main"]}"
    end

  ### Get the news

  #country(US) is hard-coded
  key2 = "1af0961e7182478ea1a8f6ecc2092f52"
  url2 = "https://newsapi.org/v2/top-headlines?country=us&apiKey=#{key2}"

  #make the call
  @news = HTTParty.get(url2).parsed_response.to_hash
  
  #create structures for headlines & url links
  @headlines = []
  @links = []
  @images= []
  for story in @news["articles"]
    @headlines << "#{story["title"]}"
    @links << "#{story["url"]}"
    @images << "#{story["urlToImage"]}"
  end

  view 'news'
end
