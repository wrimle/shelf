require 'shelf/download.rb'


module Epubify

  class Item
    attr_accessor :id, :title, :summary, :description, :cover_url, :thumbnail_url, :language, :issued

    def initialize hash = nil, &block
      summary = ""
      description = ""
      language = "no"
      issued = "#{Date.today.to_s}"

      from_hash hash if hash
      yield self if block
    end

    def self.find id
      res = ShelfApi.item(id)

      item = res["item"]
      Item.new do |i|
        i.from_hash item
      end
    end

    def from_hash h
      self.id = h["id"]
      self.title = h["title"]
      self.summary = h["summary"]
      self.description = h["description"]
      self.cover_url = h["cover_url"]
      self.thumbnail_url = h["thumbnail_url"]
      self.language = h["language"]
      self.issued = h["issued"]
    end

    def save
      @query = { :item => { :title => title, :summary => summary, :description => description, :cover_url => cover_url, :thumbnail_url => thumbnail_url, :language => language, :issued => issued } }

      if id
        res = ShelfApi.update_item(id, @query)
      else
        res = ShelfApi.create_item(@query)
        from_hash res["item"]
      end
      res
    end

    def destroy
      ShelfApi.destroy_item(id) if id
    end

    def share item_id
      @query = { :shelf_item => { :shelf_id => nil, :item_id => item_id } }
      ShelfApi.share_item(@query)
    end

    def downloads
      res = ShelfApi.downloads(id)
      d = []
      res["downloads"].each do |hash|
        d << Download.new(hash)
      end
      d
    end
  end

end
