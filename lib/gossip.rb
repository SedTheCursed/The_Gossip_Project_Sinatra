class Gossip

  attr_reader :content, :author, :id

  def initialize(props)
    @content = props["content"]
    @author = props["author"]
    # Si le gossip n'a pas d'id, il en crée un incrémentant l'id du dernier
    # Gossip de la BDD, sinon il lui affecte son id comme propriétés @id
    unless props["id"]
      file = access_gossips
      @id = file.empty? ? 1 : file[file.length - 1]["id"].to_i + 1
    else
      @id = props["id"]
    end
  end

  def save
    gossip_json = {"author" => @author, "content" => @content, "id" => @id }
    # Verifie si le Gossip est valide en verifiant que les inputs n'ont pas été
    #laissé vide, sinon abandonne le processus d'enregistement
    if gossip_json["author"].match(/^ *$/) || gossip_json["content"].match(/^ *$/)
      return
    end
    file = access_gossips

    file << gossip_json

    File.open("db/gossip.json", "w") { |f| f.puts JSON.pretty_generate(file) }
    return message = "Succes"
  end

  def update
    gossip_json = {"author" => @author, "content" => @content, "id" => @id.to_i }
    # Verifie si le Gossip est valide en verifiant que les inputs n'ont pas été
    #laissé vide, sinon abandonne le processus d'enregistement
    if gossip_json["author"].match(/^ *$/) || gossip_json["content"].match(/^ *$/)
      return
    end
    file = access_gossips
    # Modifie le Gossip de la BDD ayant le même id que le Gossip crée via les
    # données du POST
    file.map! {|gossip| gossip_json["id"] == gossip["id"] ? gossip_json : gossip }
    File.open("db/gossip.json", "w") { |f| f.puts JSON.pretty_generate(file) }
  end

  def self.all
    gossips = Array.new
    file = self.access_gossips
    file.each { |gossip| gossips << Gossip.new(gossip) }

    gossips
  end

  def self.find(id)
    id = id.to_i
    file = self.access_gossips
    gossip = file.select { |gossip| gossip["id"] == id }
    Gossip.new(gossip[0])
  end

  private
  # Deux fonction recuperant la BDD, l'une pour les méthodes d'instance,
  # l'autre pour les methodes de classe
  def access_gossips
    json = File.read("db/gossip.json")
    JSON.parse(json)
  end

  def self.access_gossips
    json = File.read("./db/gossip.json")
    JSON.parse(json)
  end
end