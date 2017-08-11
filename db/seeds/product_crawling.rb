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

Material.first(100).each do |m|
  keyword = m.name
  puts keyword
  url = "http://www.coupang.com/np/search?component=194176&q=" + URI.encode(keyword) + "&channel=user"
  data = Nokogiri::HTML(open(url))
  if !data.nil?
    product = data.css('li.search-product a dl').first
    if product.css('dd.descriptions div.price-area strong.price-value').first.nil?
      # 에러 있는 부분. Fix 할것
      product = data.css('li.search-product a dl').second
    end
    name = product.css('dd.descriptions div.name').text
    description =  make_ourform(name)
    price = product.css('dd.descriptions div.price-area strong.price-value').first.text
    image = product.css('dt.image img').attr('src').text.delete('//')
    product = Product.new(price: price, image: image, name: description["name"],
                          weight: description["weight"], bundle: description["bundle"],
                          material_id: m.id)
    if product.save!
      puts "#{product.name} is created"
    end
  end
end

