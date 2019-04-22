class Gossip

  attr_reader :content, :author, :id

  def initialize(props)
    @content = props["content"]
    @author = props["author"]
    unless props["id"]
      file = access_gossips
      @id = file.empty? ? 1 : file[file.length - 1]["id"].to_i + 1
    else
      @id = props["id"]
    end
  end

  def save
    gossip_json = {"author" => @author, "content" => @content, "id" => @id }
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
    if gossip_json["author"].match(/^ *$/) || gossip_json["content"].match(/^ *$/)
      return
    end
    file = access_gossips
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

  def access_gossips
    json = File.read("db/gossip.json")
    JSON.parse(json)
  end

  def self.access_gossips
    json = File.read("./db/gossip.json")
    JSON.parse(json)
  end
end