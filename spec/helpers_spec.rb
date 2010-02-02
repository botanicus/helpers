# encoding: utf-8

require_relative "spec_helper"
require_relative "../lib/helpers"

include Helpers

describe "Helpers::HtmlAttrsMixin#to_html_attrs" do
  before(:each) do
    @attrs = {href: "http://google.com", id: "link", "data-type" => :external}
    @attrs.extend(HtmlAttrsMixin)
  end

  it "should convert a hash into a string" do
    @attrs.to_html_attrs.should eql(" href='http://google.com' id='link' data-type='external'")
  end
end

describe "Helpers::SelfCloseTag" do
  it "should " do
    SelfCloseTag.new(:br).to_s.should eql("<br />")
  end

  it "should " do
    SelfCloseTag.new(:br, id: "clear").to_s.should eql("<br id='clear' />")
  end
end

describe "Helpers::Tag" do
  it "should " do
    Tag.new(:a).to_s.should eql("<a></a>")
  end

  it "should " do
    Tag.new(:a, id: "link").to_s.should eql("<a id='link'></a>")
  end

  it "should " do
    Tag.new(:a, "title", id: "link").to_s.should match(%r[<a id='link'>\s*title\s*</a>])
  end
end
