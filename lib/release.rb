class Release
  attr_accessor :artist, :release_name, :release_date, :mbid, :id, :release_image, :summary
  def artist=(artist)
    @artist = artist
  end
  def release_name=(value)
    @release_name = value
  end
  def release_date=(value)
    @release_date = value
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
end