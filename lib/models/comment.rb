class Comment
  attr_reader :content, :comment_id, :gossip_id

  def initialize(props)
    @content = props["content"]
    @gossip_id = props["gossip_id"].to_i
    # Si le comment n'a pas d'id, il en crée un incrémentant l'id du dernier
    # Comment de la BDD, sinon il lui affecte son id comme propriété @id
    unless props["comment_id"]
      file = access_comments
      @comment_id = file.empty? ? 1 : file[file.length - 1]["comment_id"].to_i + 1
    else
      @comment_id = props["comment_id"].to_i
    end
  end

  def save
    comment_json = {"content" => @content, "comment_id" => @comment_id, "gossip_id" => @gossip_id }
    # Verifie si le comment est valide en verifiant que le content n'a pas été
    # laissé vide, sinon abandonne le processus d'enregistement
    if comment_json["content"].match(/^ *$/)
      return
    end
    file = access_comments

    file << comment_json

    File.open("db/comment.json", "w") { |f| f.puts JSON.pretty_generate(file) }
  end

  # Selectionne les commentaires ayant le même gossip_id que le paramêtre
  # et retourne un tableau de Comments
  def self.find_by_gossip(gossip_id)
    gossip_id = gossip_id.to_i
    file = self.access_comments
    file
      .select { |comment| comment["gossip_id"].to_i == gossip_id }
      .map! { |comment| Comment.new(comment) }
  end

  private

  # Deux fonctions recuperant la BDD, l'une pour les méthodes d'instance,
  # l'autre pour les methodes de classe
  def access_comments
    json = File.read("db/comment.json")
    JSON.parse(json)
  end

  def self.access_comments
    json = File.read("db/comment.json")
    JSON.parse(json)
  end
end