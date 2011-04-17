# Andrew Horsman
# Helper methods.

module Helper

  def self.display_price(canadian_price)
    temp = canadian_price
    temp = "$#{temp} CDN" unless temp == "N/A"
  end

end
