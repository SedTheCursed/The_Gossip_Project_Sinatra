require "models/gossip"
require "models/comment"

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

  # Affiche un potin et les commentaires liés d'après son id
  get '/gossips/:id' do
    erb :show, locals: {gossip: Gossip.find(params["id"]), comments: Comment.find_by_gossip(params["id"])}
  end

  # Enregistre un nouveau commentaire et affiche la page du potin auquel 
  # il est lié.
  post '/gossips/:id' do
    Comment.new(params).save
    redirect "/gossips/#{params["id"]}"
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