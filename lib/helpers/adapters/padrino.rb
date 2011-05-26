# encoding: utf-8

require "helpers"
require "helpers/general"
require "helpers/assets"

module Helpers
  def self.registered(app)
    app.helpers Helpers::General
    app.helpers Helpers::Assets
  end
end
