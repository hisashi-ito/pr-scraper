#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【sample】
#
require "bundler/setup"
require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--lang=ja")
options.add_argument('--headless')

begin
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.get "https://qiita.com/"
  sleep 5
  driver.save_screenshot "#{Time.now.to_i}.png"
ensure
  driver.close unless driver.nil?
  driver.quit unless driver.nil?
end
