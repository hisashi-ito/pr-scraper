#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【facebook_scraper】
#
#  概要: Facebook の情報を
#       PRTIMESの特定のキーワードで検索して情報を抽出する
#       https://prtimes.jp/topics/keywords/Facebook
#
#  更新履歴:
#           2020.08.10 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require 'prtimes_scraper'

class FacebookScraper < PrimesScraper
	URL = "https://prtimes.jp/topics/keywords/Facebook"

	#= 初期化
	def initialize(logger, params, from, to)
		super(logger, params, from, to)
	end # initialize

	def scrape()
		super(URL)
	end # scrape 
end # facebook scaraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  facebook = FacebookScraper.new(logger, params, from, to)
	p facebook.scrape()
end
