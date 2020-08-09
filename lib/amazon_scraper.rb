#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【amazon_scraper】
#
#  概要: Aamazon の情報を
#       PRTIMESの特定のキーワードで検索して情報を抽出する
#       https://prtimes.jp/topics/keywords/Amazon
#
#  更新履歴:
#           2020.08.10 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require 'prtimes_scraper'

class AmazonScraper < PrimesScraper
	URL = "https://prtimes.jp/topics/keywords/Aamazon"

	#= 初期化
	def initialize(logger, params, from, to)
		super(logger, params, from, to)
	end # initialize

	def scrape()
		super(URL)
	end # scrape 
end # google scaraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  amazon = AmazonScraper.new(logger, params, from, to)
	p amazon.scrape()
end
