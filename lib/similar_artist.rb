class SimilarArtist
  attr_accessor :name, :mbid, :url, :match
  def initialize(name, mbid, url, match)
    self.name = name
    self.mbid = mbid
    self.url  = url
    self.match = match
  end
  def name=(name)
    @name = name
  end
  def mbid=(mbid)
    @mbid = mbid
  end
  def url=(url)
    @url = url
  end
  def match=(match)
    @match = (match.to_f * 100).to_i
  end
end