require 'nokogiri'
require 'open-uri'
require 'json'
require 'uri'

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
