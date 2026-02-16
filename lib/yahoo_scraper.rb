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
#        selenium の操作法
#        - https://qiita.com/mochio/items/dc9935ee607895420186
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
  # URL
  URL = "https://about.yahoo.co.jp/pr/"
  # 最大クリック回数(ボタンがなくなるまでクリックする)
  MAX_CLICK_NUM = 30
  
  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
    # Selenium を起動
    @options = Selenium::WebDriver::Chrome::Options.new
    @options.binary = ENV['CHROME_BIN'] if ENV['CHROME_BIN']
    @options.add_argument("--lang=ja")
    @options.add_argument('--headless=new')
    @options.add_argument('--no-sandbox')
    @options.add_argument('--disable-dev-shm-usage')
  end # initialize

  #= スクレイプ
  #  プレリリースの親ページから指定期内のリンク情報を取得する
  #  期間内のデータを取得するまでpagingを実施する。
  def scrape()
    link_info = []
    begin
      driver = Selenium::WebDriver.for :chrome, options: @options
      driver.get(URL)
      begin
        MAX_CLICK_NUM.times{
          driver.find_element(:xpath, "/html/body/div[3]/main/div[2]/div[2]/div/p/a").click
        }
      rescue
        # xpath から情報を抽出
        driver.find_elements(:xpath, "//div[@class='col1-3 panel-vertical']/a").each do |x|
          elems = x.text.split("\n")
          title = elems[1]
          date = elems[2]
          utime = Time.strptime(date, "%Y.%m.%d").to_i
          time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
          link = x.attribute('href')
          link_info.push([utime, link, time_str, title])
        end
      end
    ensure
      driver.quit unless driver.nil?
    end
    
    # リンク先のコンテンツを保存
    ret = []
    link_info.sort!
    link_info.each do |elems|
      utime, link, time_str, title = elems
      sleep SLEEP
      # 時間が指定の範囲にあるかどう
      if @from <= utime and utime <= @to
        ary = link_body(link)
        if ary == nil
          ret.push([time_str, title ,link, ""])
        else
          body = trim(ary[1])
          ret.push([time_str, title ,link, body])
        end
      end
    end
    return ret
  end
end # yahoo scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  yahoo = YahooScraper.new(logger, params, from, to)
  p yahoo.scrape()
end
