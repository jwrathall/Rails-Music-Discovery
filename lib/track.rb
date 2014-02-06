class Track
  attr_accessor :name, :duration, :mbid, :duration_in_minutes
  def name=(value)
    @name = value
  end
  def duration=(value)
    @duration = value.to_i
  end
  def duration_in_minutes
    seconds = @duration % 60
    minutes = @duration / 60
    @duration_in_minutes = minutes.to_s + ':' + seconds.to_s
  end
  def mbid=(value)
    @mbid = value
  end
end