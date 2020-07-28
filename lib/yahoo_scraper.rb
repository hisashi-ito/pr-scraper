#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【yahoo_scraper】
#
#  概要: Yahoo! Japan プレスリリース
#        https://about.yahoo.co.jp/pr/
#        のニュースリリース情報を抽出する
#
#        ボタン押下でPRが増えるので、selenium を利用する必要があり
#
#  更新履歴:
#           2020.07.28 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class YahooScraper < BaseScraper
  URL_TOP = "https://about.yahoo.co.jp/pr/"
  
end # yahoo scraper
