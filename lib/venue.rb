class Venue
  attr_accessor :name, :geo_location,:city, :country,:street,:postal_code, :phone, :website

  def name=(name)
    @name = name
  end
  def geo_location=(location)
    @geo_location = location
  end
  def city=(city)
    @city = city
  end
  def country=(country)
    @country = country
  end
  def street=(street)
    @street = street
  end
  def postal_code=(postal_code)
    @postal_code = postal_code
  end
  def phone=(phone)
    @phone = phone
  end
  def website=(website)
    @website = website
  end
end
