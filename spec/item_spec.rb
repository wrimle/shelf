# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'


module Epubify
  config = YAML::load(File.open("config/config.yaml"))

  ShelfApi.api_key= config["test"]["api_key"]
  ShelfApi.base_uri config["test"]["server"]


  describe Item do
    before(:each) do
    end


    it "finds an item" do
      item = Item.find(1)
      item.id.should be 1
      item.title.should_not be_nil
    end


    it "updates a download" do
      item = Item.find(1)
      old_title = item.title
      new_title = "Test title"

      item.title = new_title
      item.save

      item = Item.find(1)
      item.title.should eql new_title

      # Restore original value
      item.title = old_title
      item.save
    end


    it "gets the downloads of an item" do
      item = Item.find(1)
      downloads = item.downloads
      downloads.length.should be > 0
      downloads[0].id.should_not be_nil
    end


    it "creates an item" do
      count = Shelf.new.items.length

      item = Epubify::Item.new
      item.title = "MyDaily #{Date.today.to_s}"
      item.summary = "Daily news aggregated at #{DateTime.now.to_s}"
      item.save

      Shelf.new.items.length.should be > count
      item.id.should_not be_nil
    end


    it "destroys an item" do
      items = Shelf.new.items
      count = items.length
      count.should be > 1
      item = items.pop
      item.destroy

      Shelf.new.items.length.should be < count
    end

  end

end
