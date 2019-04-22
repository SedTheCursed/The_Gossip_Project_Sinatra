require "gossip"

class ApplicationController < Sinatra::Base
  # Affiche tous les potin en page d'accueil
  get '/' do
    erb :index, locals: {gossips: Gossip.all}
  end

  # Affichage du formulaire de création de potin
  get '/gossips/new' do
    erb :new_gossip
  end

  # Crée un nouveau potin et redirige sur la page d'accueil
  post '/gossips/new' do
    message = Gossip.new(params).save
    redirect '/'
  end

  # Affiche un potin d'après son id
  get '/gossips/:id' do
    erb :show, locals: {gossip: Gossip.find(params["id"])}
  end

  # Affichage du formulaire de modification d'un potin
  get '/gossips/:id/edit' do
    erb :edit, locals: {gossip: Gossip.find(params["id"])}
  end
  
  # Modifie un potin avant rediriger vers sa page individuelle
  post '/gossips/:id/edit' do
    Gossip.new(params).update
    redirect "/gossips/#{params["id"]}"
  end
end