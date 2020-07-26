#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【baidu_scraper】
#
#  概要: メルカリ(mercari) プレスリリース
#        https://about.mercari.com/press/news/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.24 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class MercariScraper < BaseScraper
  # トップページ
  URL_TOP = "https://about.mercari.com/press/news/"
  # トップ以降のページ
  URL = "https://about.mercari.com/press/news/?page="
  
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
    doc.xpath("//li[@class='list-block__item']/a").each do |x|
      link = x.attribute("href").value
      link = 'https://about.mercari.com/' + link if link !~ (/^http/)
      date = x.xpath("div/div/div[@class='date']")[0].text
      utime = Time.strptime(date, "%Y.%m.%d").to_i
      time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
      title = x.xpath("div/div[@class='title regular']").text
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
  end
  
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
end


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  docomo = MercariScraper.new(logger, params, from, to)
  p docomo.scrape()
end
