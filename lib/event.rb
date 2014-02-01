class Event
  attr_accessor :title,:artists,:venue,:date,:is_today, :phone, :website

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
    time = Time.parse(date)
    @date = time
  end
  def is_today
    is_today = false
    today = Time.now
    event_date = Date.new(@date.year,@date.month, @date.day)
    if today.day == event_date.day && today.month == event_date.month
      is_today = true
    end
    @is_today = is_today
  end
  def phone=(phone)
    @phone = phone
  end
  def website=(website)
    @website = website
  end
end