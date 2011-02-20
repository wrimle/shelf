
require 'rubygems'
require 'httparty'
require 'date'

module Epubify
  class ShelfApi
    include HTTParty

    base_uri 'shelf.epubify.com'

    def self.api_key
      @api_key
    end

    def self.api_key= k
      @api_key = k
    end

    def self.items
      get "/api/#{api_key}/items.xml"
    end

    def self.item id
      get "/api/#{api_key}/items/#{id}.xml"
    end

    def self.update_item id, query
      put("/api/#{api_key}/items/#{id}.xml", :query => query)
    end

    def self.create_item query
      post("/api/#{api_key}/items.xml", :query => query)
    end

    def self.destroy_item id
      delete("/api/#{api_key}/items/#{id}.xml")
    end


    def self.share_item query
      post("/api/#{api_key}/shelf_items.xml", :query => query)
    end


    def self.downloads item_id
      get "/api/#{api_key}/downloads.xml", :query => { :item_id => item_id }
    end

    def self.download id
      get "/api/#{api_key}/downloads/#{id}.xml"
    end


    def self.update_download id, query
      put("/api/#{api_key}/downloads/#{id}.xml", :query => query)
    end

    def self.create_download query
      post("/api/#{api_key}/downloads.xml", :query => query)
    end

    def self.destroy_download id
      delete("/api/#{api_key}/downloads/#{id}.xml")
    end

  end


end


require 'shelf/download.rb'
require 'shelf/item.rb'


module Epubify

  class Shelf
    def initialize
      @items = nil
    end


    def items
      unless @items
        res = ShelfApi.items
        @items = []
        res["items"].each do |hash|
          @items << Item.new(hash)
        end
      end
      @items
    end

  end

end
