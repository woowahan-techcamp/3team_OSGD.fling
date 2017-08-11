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
  puts subtitle
end


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


