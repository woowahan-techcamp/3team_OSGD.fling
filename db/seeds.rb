# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

require 'nokogiri'
require 'open-uri'
require 'json'
require 'uri'

data = Nokogiri::HTML(open("http://haemukja.com/recipes/137"))
if !data.nil?
  title = data.css('div.aside h1 strong').text
  subtitle = data.css('div.aside h1').text.strip
  image = data.css('ul.slides li img').first.attr('src')
  user = data.css('strong.best a').text
  puts subtitle.split("  ")[0]
end




=begin
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
=end


# for recipe crawilng
=begin
(37..70).each do |index|
  url = "http://haemukja.com/recipes/" + index.to_s
  input = Nokogiri::HTML(open(url))
  title = input.css('div.aside h1 strong').text
  input.css("div.btm li").each do |li|
    name = li.css('span').text.delete(' ')
    un_unit = li.css('em').text.delete(' ')
      unit = un_unit.split(/(?<=\d)(?=[ㄱ-ㅎ|가-힣|a-z|A-Z|])/).last
    if !un_unit.nil? && !unit.nil?
      name = name.split("(").first
      unit = unit.split("(").first
      puts "#{title} #{name} >> #{unit}"
    end
  end
end
=end

=begin
def validate(string)
  validate_string = ["말린것", "마른것", "삶은것", "찐것", "볶은것", "각종", "익힌것", "데친것"]
  result = string
  validate_string.each do |word|
    if string.include? word
      result = string.delete(word).delete(" ")
    end
  end
  return result
end
(1..19).each do |index|
  url = "http://haemukja.com/get_bf_group_items.json?bf_group_id=" + index.to_s
  input = JSON.load(open(url))
  input.each do |material|
    name = validate(material["name"])
    if name == "소멘"
      name = "소면"
    end
    if Material.where(name: name).count == 0
      material = Material.new(name: name)
      if material.save!
        puts "#{material.name} is created"
      end
    end
  end
end
=end
