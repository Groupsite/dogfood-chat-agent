require 'nokogiri'
require 'ostruct'
require 'active_support'
require 'active_support/core_ext/string'
require 'xml_parser'
require 'httparty'

class PivotalActivity < OpenStruct
  def self.from_xml(xml_string)
    document = Nokogiri.XML(xml_string)
    list = document.css("activity").map do |node|
      XmlParser.parse_xml_node_to_object(node, self)
    end
    list.size < 2 ? list.first : list
  end

  def story
    unless defined?(@story)
      response = HTTParty.get(stories.first.url, :headers => {"X-TrackerToken" =>
"7a5f72ace802af1767c79422df62b0e6"})
      document = Nokogiri.XML(response.body)
      @story = XmlParser.parse_xml_node(document.at("story"))
    end
    @story
  end

  def html_summary
    html = []
    if event_type == "note_create"
      html << "<p>Comment added to #{story.name}:</p>"
      html << "<p>#{description}</p>"
    else
      html << "<p>#{description}</p>"
    end
    html << "<p>#{story.url}</p>"
    html.join("\n")
  end
end
