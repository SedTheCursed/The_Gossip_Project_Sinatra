require "gossip"

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: {gossips: Gossip.all}
  end

  get '/gossips/new' do
    erb :new_gossip
  end

  post '/gossips/new' do
    message = Gossip.new(params).save
    redirect '/'
  end

  get '/gossips/:id' do
    erb :show, locals: {gossip: Gossip.find(params["id"])}
  end

  get '/gossips/:id/edit' do
    erb :edit, locals: {gossip: Gossip.find(params["id"])}
  end
  
  post '/gossips/:id/edit' do
    Gossip.new(params).update
    redirect "/gossips/#{params["id"]}"
  end
end