require 'json'

module JsonInterface

  def JsonInterface.save_into_json_file(data, file)
    File.open(file,"w") do |f|
      f.write(JSON.pretty_generate(data))
    end
  end

  def JsonInterface.get_datas_from_json_file(file)
    json = File.read(file)
    JSON.parse(json)
  end

end


if __FILE__ == $0
  #data = ['t', 'e', 's', 't']
  #JsonInterface.save_into_json_file(data, 'test.json')
  p JsonInterface.get_datas_from_json_file('db/contacts.json')
end
