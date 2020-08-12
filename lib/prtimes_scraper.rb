#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【prtimes_scraper】
#
#  概要: PRTIMESの特定のキーワードで検索して情報を抽出する
#       https://prtimes.jp/topics/keywords/{keyword}
#
#        ボタン押下でPRが増えるので、selenium を利用する必要があり
#
#        selenium の操作法https://prtimes.jp/
#        - https://qiita.com/mochio/items/dc9935ee607895420186
#
#        Mac で環境を構築する場合は
#        - https://qiita.com/w5966qzh/items/4c1164bd7c611820c187
#
#  更新履歴:
#           2020.08.10 新規作成
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

class PrimesScraper < BaseScraper
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
    @options.add_argument("--lang=ja")
    @options.add_argument('--headless')
  end # initialize
  
  #= スクレイプ
  #  プレリリースの親ページから指定期内のリンク情報を取得する
  #  期間内のデータを取得するまでpagingを実施する。
  def scrape(url)
    link_info = []
    begin
      driver = Selenium::WebDriver.for :chrome, options: @options
      driver.get(url)
      
      begin
     	MAX_CLICK_NUM.times{
	  sleep 1
          driver.find_element(:xpath, "//*[@id='more-load-btn-view']").click
	}
      rescue
	@logger.info("clickできなくなくりました...")
      end
      
      # xpath から情報を抽出
      driver.find_elements(:xpath, "//article").each do |x|
	elems = x.text.split("\n")
	next if elems.size() == 0
        # 発表日時の書き方が微妙にずれているのでチェンジ
	title = elems[0]
	begin
	  date = elems[1].split(" ")[0]
	  campany = elems[2]
	  utime = Time.strptime(date, "%Y年%m月%d日").to_i
	  time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
	rescue
          begin
	    date = elems[2].split(" ")[0]
	    campany = elems[1]
	    utime = Time.strptime(date, "%Y年%m月%d日").to_i
	    time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
          rescue
            next
          end
	end
	title = title + " 関連企業:" + campany
	link = x.find_element(:xpath, "a").attribute("href")
        link_info.push([utime, link, time_str, title])
      end
    ensure
      driver.close unless driver.nil?
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
  end # scrape
end # primes scraper
