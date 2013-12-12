require "open-uri"

require File.expand_path("models/router")

class SetRoutersContactInfo
  TOR_NODES_URL = "https://www.dan.me.uk/tornodes".freeze
  BEGIN_TOR_NODE_LIST = "<!-- __BEGIN_TOR_NODE_LIST__ //-->".freeze
  END_TOR_NODE_LIST = "<!-- __END_TOR_NODE_LIST__ //-->".freeze

  TOR_NODES_SEPARATOR = "<br />\n".freeze
  FIELD_SEPARATOR = "|".freeze
  IP_ADDRESS_INDEX = 0
  NAME_INDEX = 1
  CONTACT_INFO_INDEX = 7
  HTML_ENTITY_REGEXP = /&\w+;/

  class Node
    attr_reader :ip_address, :name, :contact_info

    def initialize(ip_address, name, contact_info)
      @ip_address, @name = ip_address, name
      self.contact_info = contact_info
    end

    def contact_info=(info)
      @contact_info = info.gsub(HTML_ENTITY_REGEXP, "")
    end
  end

  def self.execute
    html = open(TOR_NODES_URL).read
    begin_index = html.index(BEGIN_TOR_NODE_LIST) + BEGIN_TOR_NODE_LIST.length + 1
    end_index = html.index(END_TOR_NODE_LIST)
    nodes_html = html[begin_index, end_index - begin_index]

    nodes = nodes_html.split(TOR_NODES_SEPARATOR)
    nodes = nodes.map do |node|
      arr = node.split(FIELD_SEPARATOR)
      Node.new(arr[IP_ADDRESS_INDEX], arr[NAME_INDEX], arr[CONTACT_INFO_INDEX]) if arr.length > CONTACT_INFO_INDEX
    end.compact!

    nodes.each do |node|
      Router.where(ip_address: node.ip_address, name: node.name).update(contact_info: node.contact_info)
    end
  end
end
