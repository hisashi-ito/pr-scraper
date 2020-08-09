#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【_scraper】
#
#  概要: microsoft プレスリリース
#       https://news.microsoft.com/ja-jp/category/press-releases/
#       のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.08.08 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
require 'extractcontent'
SLEEP = 0.25

class MicrosoftScraper < BaseScraper
  # トップページ
  URL_TOP = "https://news.microsoft.com/ja-jp/category/press-releases/"
  # トップ以降のページ
  URL = "https://news.microsoft.com/ja-jp/category/press-releases/page/"
  
  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
  end # initialize
  
  #= スクレイプ
  #  プレリリースの親ページから指定期内のリンク情報を取得する
  #  期間内のデータを取得するまでpagingを実施する。
  def _scrape(url)
    ret = []
    times = []
    link_info = []
    html = request(url) # URLは固定
    doc = parse(html)
    doc.xpath("//article/div[@class='m-preview-content']").each do |x|
      link = x.xpath("a").attribute("href").value
      title = trim(x.xpath("a").text)
      # URLのpathから日付を同定する(リアルな日付はリンク先しかないがめんどい)
      # https://news.microsoft.com/ja-jp/2020/07/01/200701-skillingprogram
      if link =~ (/^https:\/\/news\.microsoft\.com\/ja\-jp\/(\d+)\/(\d+)\/(\d+)\//)
	year = $1
	month = $2
	day = $3
	utime = Time.local(year, month, day).to_i
	time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
	link_info.push([utime, link, time_str, title])
      end
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
  end # _scraper
  
  def scrape()
    # 最初にトップのURLから収集
    ret = _scrape(URL_TOP)
    # 10ページまで一応ページング
    2.upto(10){|x|
      url = "#{URL}#{x}"
      _ret = _scrape(url)
      break if _ret.size == 0 && ret.size != 0
      ret.concat(_ret)
    }
    return ret
  end
end # maicrosoft scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  microsoft = MicrosoftScraper.new(logger, params, from, to)
  p microsoft.scrape()
end
