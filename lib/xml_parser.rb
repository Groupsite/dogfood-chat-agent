module XmlParser
  def parse_xml_node(node)
    first_child = node.first_element_child
    if first_child.nil?
      parse_xml_node_to_scalar(node)
    elsif first_child.node_name.pluralize == node.node_name
      parse_xml_node_to_array(node)
    else
      parse_xml_node_to_object(node)
    end
  end

  def parse_xml_node_to_scalar(node)
    case node["type"]
    when "integer"
      Integer(node.text)
    when "datetime"
      DateTime.parse(node.text)
    else
      node.text
    end
  end

  def parse_xml_node_to_object(node, type = OpenStruct)
    attribute_node = node.first_element_child
    hash = {}
    while attribute_node
      hash[attribute_node.node_name] = parse_xml_node(attribute_node)
      attribute_node = attribute_node.next_element
    end
    type.new(hash)
  end

  def parse_xml_node_to_array(node)
    element_node = node.first_element_child
    array = []
    while element_node
      array << parse_xml_node(element_node)
      element_node = element_node.next_element
    end
    array
  end

  extend self
end
