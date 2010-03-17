# encoding: utf-8

require "helpers"
require "helpers/general"
require "helpers/forms"
require "helpers/assets"

Rango::Helpers.send(:include, Helpers::General)
Rango::Helpers.send(:include, Helpers::Assets)
