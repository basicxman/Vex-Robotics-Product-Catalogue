#!/usr/bin/env ruby

# Andrew Horsman
# Generates a static HTML file containing a table of all Vex products.

require 'json/pure'

products = JSON.parse(File.read("./products.json"))
File.open("static.html", "w") do |file|
  
  # HTML start.
  file.puts <<-eof
    <!DOCTYPE html>

    <html>

      <head>

        <meta charset=utf-8 />

        <title>Vex Robotics Product Catalogue</title>

        <link rel="stylesheet" type="text/css" href="style-all.css" />

      </head>

      <body>

        <table id="product-catalogue">

          <thead>
            <tr>
              <th scope="col" id="image-header">Image</th>
              <th scope="col" id="name-header">Name</th>
              <th scope="col" id="category-header">Category</th>
              <th scope="col" id="description-header">Description</th>
              <th scope="col" id="price-header">Price</th>
              <th scope="col" id="product-number-header">SKU</th>
            </tr>
          </thead>

          <tbody>

  eof
  # HTML start.

  products.each do |product|
    file.puts <<-eof
      <tr>
        <td class="image-row"><img src="#{product['image']}" alt="#{product['name']} | #{product['category']}" title="#{product['name']} | #{product['category']}" /></td>
        <td class="name-row"><a href="#{product['url']}" title="#{product['name']}" target="_blank">#{product['name']}</a></td>
        <td class="category-row">#{product['category']}</td>
        <td class="description-row"><span>#{product['desc']}</span>#{product['shortdesc']}</td>
        <td class="price-row">$#{product['price']}</td>
        <td class="sku-row">#{product['sku']}</td>
      </tr>
    eof
  end
  

  # HTML end.  
  file.puts <<-eof
          </tbody>

        </table>

      </body>

    </html>
  eof
  # HTML end.

end
