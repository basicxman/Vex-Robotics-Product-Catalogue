#!/usr/bin/env ruby

# Andrew Horsman
# Vex Product Data Collection

require 'nokogiri'
require 'open-uri'
require 'json/pure'

product_pages = %w(
  http://www.vexrobotics.com/products/accessories/motion
  http://www.vexrobotics.com/products/accessories/structure
  http://www.vexrobotics.com/products/accessories/power
  http://www.vexrobotics.com/products/accessories/sensors
  http://www.vexrobotics.com/products/accessories/logic
  http://www.vexrobotics.com/products/accessories/control
  http://www.vexrobotics.com/products/accessories/equipment
)

products_index = []

product_pages.each do |product_listing_url|
  
  page     = Nokogiri::HTML(open("#{product_listing_url}?mode=list"))
  category = product_listing_url[product_listing_url.rindex('/') + 1..-1].capitalize
  products = page.css(".listing-item") 
  products.each do |product|
    temp = {}
    temp[:image] = product.css(".product-image img").attr("src").value
    temp[:name]  = product.css(".product-shop h5 a").text
    temp[:price] = product.css(".price-box .price").text.gsub(/[^0-9\.]/, '')
    temp[:desc]  = product.css(".product-shop .description").to_html
    temp[:shortdesc] = product.css(".product-shop .description p").text[0..50]
    temp[:sku]   = product.css(".product-sku").text.gsub("P/N: ", "")
    temp[:url]   = product.css(".product-shop a").attr("href").value
    temp[:category] = category
    products_index << temp
  end

end

File.open("products.json", "w") do |db|
  db.print JSON.pretty_generate(products_index)
end
