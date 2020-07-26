#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【dmm_scraper】
#
#  概要: DMM プレスリリース
#        https://dmm-corp.com/press/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.26 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class DmmScraper < BaseScraper
  URL_TOP = 'https://dmm-corp.com/press/'
  URL = 'https://dmm-corp.com/press/page/'

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
    link_info = []
    html = request(url)
    doc = parse(html)
    title = nil
    doc.xpath("//li[@class='p-article-li__item']/a").each do |x|
      link = x.attribute("href").value
      title = x.xpath("div/h1[@class='c-sect__tl c-sect__tl--li']").text
      date = x.xpath("div/div/div[@class='c-sect__st__time']").text
      date = trim(date).split(" ")[0]
      utime = Time.strptime(date, "%Y/%m/%d").to_i
      time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
      link_info.push([utime, link, time_str, title])
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
  end # scrape
end # dmm scraper 


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  dmm = DmmScraper.new(logger, params, from, to)
  p dmm.scrape()
end
