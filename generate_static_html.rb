#!/usr/bin/env ruby

# Andrew Horsman
# Generates a static HTML file containing a table of all Vex products.

require 'json/pure'
require File.expand_path("helpers", File.dirname(__FILE__))

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
        <link rel="stylesheet" type="text/css" href="css/ui-lightness/jquery.css" />

      </head>

      <body>
        
        <table id="product-catalogue">

          <thead>
            <tr>
              <th scope="col" id="image-header">Image</th>
              <th scope="col" id="name-header">Name</th>
              <th scope="col" id="category-header">Category</th>
              <th scope="col" id="description-header">Description (click any text to expand)</th>
              <th scope="col" id="price-header">Price</th>
              <th scope="col" id="product-number-header">SKU</th>
              <th></th>
            </tr>
          </thead>

          <tbody>

  eof
  # HTML start.

  index = 0
  classes_done = []
  products.each_key do |key|
    product = products[key]
    row_class = ""
    unless classes_done.include? product['category']
      classes_done << product['category']
      row_id = product['category']
    end

    file.puts <<-eof
      <tr class="#{index}" id="#{row_id}">
        <td class="image-row"><img src="#{product['image']}" alt="#{product['name']} | #{product['category']}" title="#{product['name']} | #{product['category']}" /></td>
        <td class="name-row"><a href="#{product['url']}" title="#{product['name']}" target="_blank">#{product['name']}</a><br />#{Helper::meta_for_name_row(product)}</td>
        <td class="category-row">#{product['category']}</td>
        <td class="description-row"><span class="full-description">#{product['desc']}</span><span class="short-description">#{product['shortdesc']}</span></td>
        <td class="price-row">#{Helper::display_price(product['price'])}</td>
        <td class="sku-row">#{product['sku']}</td>
        <td><a href="#" title="Go to top" style="text-decoration:none;">&uarr;</a><br /><br /><a href="##{product['category']}" title="Go to #{product['category']}" style="text-decoration:none;">&crarr;</a></td>
      </tr>
    eof
    index += 1
  end
  

  # HTML end.  
  file.puts <<-eof
          </tbody>

        </table>

        <div id="footer">
          <p>Please note that this site is not affiliated with Vex Robotics and/or Innovation First.  Vex Robotics is not responsible for any content here and pricing, descriptions and other data is subject to change.  This page was generated on <b>#{Time.now}</b>.</p>
          <p>All pricing is in Canadian dollars.  There are #{products.length} products in this catalogue.</p>
          <p><a href="#" title="Back to Top">Back to Top</a></p>
        </div>
        
        <script type="text/javascript" src="analytics.js"></script>
        <script type="text/javascript" src="jquery.js"></script>
        <script type="text/javascript" src="jquery-ui.js"></script>
        <script type="text/javascript" src="main.js"></script>

      </body>

    </html>
  eof
  # HTML end.

end
