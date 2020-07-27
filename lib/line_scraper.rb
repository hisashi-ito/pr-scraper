#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【line_scraper】
#
#  概要: LINE株式会社 プレスリリース
#        https://linecorp.com/ja/pr/news/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.27 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class LineScraper < BaseScraper
  URL_TOP = "https://linecorp.com/ja/pr/news/"
  URL = "https://linecorp.com/ja/pr/news/ja/all/2020/"
  
  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
  end # initialize

  #= スクレイプ
  #  プレリリースの親ページから指定期内のリンク情報を取得
  def _scrape(url)
    ret = []
    times = []
    link_info = []
    html = request(url)
    doc = parse(html)
    doc.xpath("//li[@class='bx_img']").each do |x|
      link = x.xpath("a")[0].attribute("href").value
      link = "https://linecorp.com" + link if link !~ (/^http/)
      title = trim(x.xpath("a/p[@class='news_title']")[0].text).gsub(" ","")
      date = x.xpath("a/p[@class='news_inf']")[0].text.split(" ")[0]
      utime = Time.strptime(date, "%Y.%m.%d").to_i
      time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
      link_info.push([utime, link, time_str, title])
    end # doc
    
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
  end # _scrape

  def scrape()
    # 最初にトップのURLから収集
    ret = _scrape(URL_TOP)
    # 20ページまで一応ページング
    2.upto(20){|x|
      url = "#{URL}#{x}"
      _ret = _scrape(url)
      break if _ret.size == 0 && ret.size != 0
      ret.concat(_ret)
    }
    return ret
  end
end # line scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  line = LineScraper.new(logger, params, from, to)
  p line.scrape()
end

