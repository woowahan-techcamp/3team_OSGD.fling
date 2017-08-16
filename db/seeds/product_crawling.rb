require 'nokogiri'
require 'open-uri'
require 'json'
require 'uri'

def make_ourform(product_title)
  result = Hash.new
  name = ""
  weight = ""
  bundle = ""
  product_title.split(", ").each_with_index do |p, index|
    if index == 0
      name = p.strip
    elsif p.length > 5
      name = name + p.strip
    elsif p.include?("g") && p.exclude?("개")
      weight = p.strip
    else
      bundle = p.strip
    end
  end
  result["name"] = name
  result["weight"] = weight
  result["bundle"] = bundle
  return result
end

missed_material = []

Material.all.each do |m|
  keyword = m.name
  url = "http://www.coupang.com/np/search?component=194176&q=" + URI.encode(keyword) + "&channel=user"
  data = Nokogiri::HTML(open(url))
  if !data.nil?
    product = data.css('li.search-product a dl').first
    if product.respond_to?(:css) &&
        !product.css('dd.descriptions div.price-area strong.price-value').first.nil?
      name = product.css('dd.descriptions div.name').text
      puts "#{make_ourform(name)["name"]} is founded!"
      description =  make_ourform(name)
      price = product.css('dd.descriptions div.price-area strong.price-value').first.text
      image = product.css('dt.image img').attr('src').text.delete('//')
      product = Product.new(price: price, image: image,
                            name: description["name"],
                            weight: description["weight"],
                            bundle: description["bundle"],
                            material_id: m.id)
      if product.save!
        puts "#{product.name} is created"
      end
    else
      missed_material << m.name
      puts "I cannot find #{m.name}"
    end
  end
end

puts "I did create #{Product.all.count} products"
puts "but I cannot find these materials..."
puts missed_material
