# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'


module Epubify
  config = YAML::load(File.open("config/config.yaml"))


  ShelfApi.api_key= config["test"]["api_key"]
  ShelfApi.base_uri config["test"]["server"]


  describe ShelfApi do
  end


  describe Shelf do
    before(:each) do
    end

    it "lists owned items" do
      shelf = Shelf.new
      shelf.items.length.should be > 0
    end
  end

end
