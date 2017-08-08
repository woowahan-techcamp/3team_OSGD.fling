require 'nokogiri'
require 'open-uri'
require 'json'

def get_material(input)
  material = Hash.new()
  case1 = input.css('div.ready_ingre3 ul').count
  case2 = input.css('div.cont_ingre').count
  if case1 > 0
    material = case1(input)
  elsif case2 > 0
    material = case2(input)
  end
  return material
end

## 1 ul li 형식일때
def case1(input)
  material = Hash.new()
  input.css('div.ready_ingre3 ul').each do |u|
    title = u.css('b').text
    if title == "[재료]" || title == "[양념]" || title == "[소스]"
      u.css('li').each do |li|
        name = li.text.split("  ")[0]
        unit = li.css('span.ingre_unit').text
        material[name] = unit
      end
    end
  end
  return material

end
## 2 ul li가 아니라 dl일때 !! 문제점이 있다!
def case2(input)
  material = Hash.new()
  input.css('div.cont_ingre dl').each do |dl|
    dl.css('dd').text.split(',').each do |m|
      title = m.split(' ').first
      unit = m.split(' ').last
      material[title] = unit
    end
  end
  return material
end

(6855677..6855697).each do |index|
  url = "http://www.10000recipe.com/recipe/" + index.to_s
  input = Nokogiri::HTML(open(url))
  material = get_material(input)
  puts material
  material.each do |key, value|

    if Material.where(name: key).nil? && key != "" && key != " "
      name = key
      material = Material.new(name: name)
      if material.save!
        puts "#{name}is created"
      end
    end

    unit = value.split(/(?<=\d)(?=[ㄱ-ㅎ|가-힣|a-z|A-Z|])/).last
    if Unit.where(name: unit).nil? && unit != "" && unit != " "
      unit = Unit.new(name: unit)
      if unit.save!
        puts "#{name}is created"
      end
    end

  end
end
