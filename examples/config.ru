#!/usr/bin/env rackup -p 4000 -s thin
# encoding: utf-8

$:.unshift(::File.expand_path("../../lib", __FILE__))

require "helpers"

class GoogleAnalytics
  def initialize(app)
    @app = app
  end

  # And here the fun begins, in our middlewares.
  # No more body.gsub, no more 100x parsing output
  # as a nokogiri document, just use it like DOM
  # in your browser and return it back to rack
  def call(env)
    @app.call(env).tap do |response|
      body = response[2].content.find_tag { |tag| tag.name.eql?(:body) }
      body.tag(:script, src: "htpp://google.com/ga.js")
    end
  end
end

use GoogleAnalytics
use ContentLength
use ContentType

map("/") do
  run lambda { |env|
    html = Helpers::Tag.new(:html) do |html|
      html.tag(:head) do |head|
        head.tag(:title, "This is the dog's bollocks!")
      end

      html.tag(:body) do |body|
        body.tag(:h1, "Hello World!")
        body.tag(:p, class: :perex) do |p|
          p.content << "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        end
      end
    end
    [200, Hash.new, html]
  }
end
