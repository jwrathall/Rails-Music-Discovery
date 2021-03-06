class Release
  attr_accessor :artist, :release_name, :release_date, :mbid, :id, :release_image, :summary, :tracks
  def artist=(artist)
    @artist = artist
  end
  def release_name=(value)
    @release_name = value
  end
  def release_date=(value)
    time = Time.parse(value)
    @release_date = time
  end
  def mbid=(value)
    @mbid = value
  end
  def id=(value)
    @id = value
  end
  def release_image=(value)
    @release_image = value
  end
  def summary=(value)
    @summary = value
  end
  def tracks=(value)
    @tracks = value
  end
end