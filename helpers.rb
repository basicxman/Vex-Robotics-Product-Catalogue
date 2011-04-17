# Andrew Horsman
# Helper methods.

module Helper

  def self.display_price(canadian_price)
    temp = canadian_price
    temp = "$#{temp} CDN" unless temp == "N/A"
  end

  def self.meta_for_name_row(product)
    temp = "<span>"
    unless product["inventors_guide"].nil?
      temp += "<a href='#{product['inventors_guide']}' target='_blank' title='Inventors Guide PDF for #{product['name']}'>Inventors Guide</a>" 
    end

    unless product["step"].nil?
      temp += "<br /><a href='#{product['step']}' target='_blank' title='CAD STEP for #{product['name']}'>CAD STEP</a>"
    end
    temp
  end

end
