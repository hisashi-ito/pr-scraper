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
require 'selenium-webdriver'
SLEEP = 0.25

class YahooScraper < BaseScraper
  URL = "https://about.yahoo.co.jp/pr/"

  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
    # Selenium を起動
    @options = Selenium::WebDriver::Chrome::Options.new
    @options.add_argument("--lang=ja")
    @options.add_argument('--headless')
  end # initialize

  #= スクレイプ
  #  プレリリースの親ページから指定期内のリンク情報を取得する
  #  期間内のデータを取得するまでpagingを実施する。
  def scrape()
    begin
      driver = Selenium::WebDriver.for :chrome, options: @options
      driver.get URL
    ensure
      driver.close unless driver.nil?
      driver.quit unless driver.nil?e
    end
  end
end # yahoo scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  yahoo = YahooScraper.new(logger, params, from, to)
  yahoo.scrape()
end
