require 'nokogiri'
require 'open-uri'
require 'json'
require 'uri'

 #for recipe crawilng
(37..100).each do |index|
  recipe_material = []
  missed_product = []
  product_list = []
  url = "http://haemukja.com/recipes/" + index.to_s
  input = Nokogiri::HTML(open(url))
  title = input.css('div.aside h1 strong').text
  serving = input.css('div.dropdown').text
  puts serving.strip
  #input.css("div.btm li").each do |li|
    #name = li.css('span').text.delete(' ')
    #un_unit = li.css('em').text.delete(' ')
    #unit = un_unit.split(/(?<=\d)(?=[ㄱ-ㅎ|가-힣|a-z|A-Z|])/).last
    #if !un_unit.nil? && !unit.nil?
      #name = name.split("(").first
      #unit = unit.split("(").first
      #products_searched = Material.where("name LIKE ?", "#{name}")
      #recipe_material << name + " " + un_unit
      #if products_searched.count == 0
        #products_searched = Material.where("name LIKE ?", "%#{name}%")
        #if products_searched.count == 0
          #missed_product << name + " " + un_unit
        #else
          #product_list << products_searched.last.products.first
        #end
      #else
        #product_list << products_searched.last.products.first
      #end
    #end
  #end
    #puts "recipe : #{recipe_material}"
    #puts "missed product : #{missed_product}"
    #puts "find product : #{product_list}"
end
