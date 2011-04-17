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

def get_detailed_product_information(url)
  temp = {}
  page = Nokogiri::HTML(open(url))

  product_shop = page.css(".product-shop")
  temp[:desc]  = product_shop.css(".short-description").to_html

  paragraphs = product_shop.css(".short-description p")
  if paragraphs.length > 0
    temp[:shortdesc] = paragraphs.first.text
    temp[:shortdesc] = temp[:desc] if temp[:shortdesc] == ""
  else
    temp[:shortdesc] = temp[:desc] 
  end

  product_shop_prices = product_shop.css(".price-box .price")
  if product_shop_prices.length > 0
    temp[:price] = product_shop_prices.first.text.gsub(/[^0-9\.]/, '')
  else
    temp[:multiproduct] = true
    table = page.css("#super-product-table").first
    temp[:subproducts] = []
    table.css("tbody tr").each do |sub_product|
      sub_temp = {}
      data = sub_product.css("td")
      sub_temp[:name]  = data[0].text
      sub_temp[:sku]   = data[1].text
      sub_temp[:price] = data[3].text.gsub(/[^0-9\.]/, '')
      temp[:subproducts] << sub_temp
    end
  end

  temp
end

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
    temp[:sku]   = product.css(".product-sku").text.gsub("P/N: ", "")
    temp[:url]   = product.css(".product-shop a").attr("href").value
    temp[:category] = category

    temp[:price] = "N/A" if temp[:price] == ""
    temp.merge! get_detailed_product_information(temp[:url])

    if temp[:multiproduct].nil?
      products_index << temp
    else
      temp_products = []
      temp[:subproducts].each do |sub_product|
        sub_temp = temp.dup
        sub_temp[:price] = sub_product[:price]
        sub_temp[:name]  = sub_product[:name]
        sub_temp[:sku]   = sub_product[:sku]
        temp_products << sub_temp
      end
      products_index += temp_products
    end
  end

end

File.open("products.json", "w") do |db|
  db.print JSON.pretty_generate(products_index)
end
