require 'nokogiri'
require 'ostruct'

class PivotalActivity < OpenStruct
  def self.from_xml(xml_string)
    document = Nokogiri.XML(xml_string)
    list = document.css("activity").map do |node|
      hash = {}
      attribute_node = node.first_element_child
      while attribute_node
        value = case attribute_node["type"]
                when "integer"
                  Integer(attribute_node.text)
                when "datetime"
                  DateTime.parse(attribute_node.text)
                else
                  attribute_node.text
                end
        hash[attribute_node.node_name] = value
        attribute_node = attribute_node.next_element
      end
      new(hash)
    end
    list.size < 2 ? list.first : list
  end
end
