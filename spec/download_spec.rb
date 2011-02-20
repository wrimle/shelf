# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'


module Epubify
  config = YAML::load(File.open("config/config.yaml"))


  ShelfApi.api_key= config["test"]["api_key"]
  ShelfApi.base_uri config["test"]["server"]


  describe Download do
    before(:each) do
    end

    it "gets a download" do
      download = Download.find(1)
      download.id.should_not be_nil
    end


    it "updates a download" do
      download = Download.find(1)
      old_url = download.url
      new_url = "www.example.com/dummy"

      download.url = new_url
      download.save

      download = Download.find(1)
      download.url.should eql new_url

      # Restore original value
      download.url = old_url
      download.save
    end


    it "creates a download" do
      item = Item.find(1)
      count = item.downloads.length

      download = Epubify::Download.new
      download.url = "/example.epub"
      download.item_id = 1
      download.save

      item = Item.find(1)
      item.downloads.length.should be > count
      download.id.should_not be_nil
    end


    it "destroys a download" do
      item = Item.find(1)
      count = item.downloads.length
      count.should be > 1

      download = item.downloads.pop
      download.destroy


      item = Item.find(1)
      item.downloads.length.should be < count
    end

  end

end
