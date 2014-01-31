class Event
  attr_accessor :title,:artists,:venue,:date
  def title=(title)
    @title = title
  end
  def artists=(artists)
    @artists = artists
  end
  def venue=(venue)
    @venue = venue
  end
  def date=(date)
    #TODO: clean up the date format
    @date = date
  end
end