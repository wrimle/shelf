

module Epubify

  class Download
    attr_accessor :id, :item_id, :content_type, :url

    def initialize h = nil, &block
      content_type = "application/epub+zip"

      from_hash h if h
      yield self if block
    end


    def from_hash h
      self.id = h["id"]
      self.item_id = h["item_id"]
      self.content_type = h["content_type"]
      self.url = h["url"]
    end


    def item= v
      @item = v
      item_id = v.id
    end


    def item
      @item
    end


    def self.find id
      res = ShelfApi.download(id)

      download = res["download"]
      Download.new do |d|
        d.from_hash download
      end
    end


    def destroy
      ShelfApi.destroy_download(id) if id
    end


    def save
      @query = { :download => { :item_id => item_id, :content_type => content_type, :url => url } }

      if id
        res = ShelfApi.update_download(id, @query)
      else
        res = ShelfApi.create_download(@query)
        from_hash res["download"]
      end

      res
    end
    
  end
end
