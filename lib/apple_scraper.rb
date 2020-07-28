#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【dmm_scraper】
#
#  概要: Apple プレスリリース
#        https://www.apple.com/jp/newsroom/archive/
#        のニュースリリース情報を抽出する
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

class AppleScraper < BaseScraper
  URL_TOP = "https://www.apple.com/jp/newsroom/archive/"
  URL = "https://www.apple.com/jp/newsroom/archive/?page="

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
    link_info = []
    html = request(url)
    doc = parse(html)
    doc.xpath("//a[@class='result__item row-anchor result__item--type-img']").each do |x|
      title = trim(x.text).gsub(" ","")
      if title =~ (/(.+)月(.+)\,(\d{4})/)
        time_str  = "#{$3}年#{$1}月#{$2}日"
        utime = Time.strptime(time_str,'%Y年%m月%d日').to_i
      end
      link = x.attribute("href").value
      link = "https://www.apple.com" + link if link !~ (/^http/)
      link_info.push([utime, link, time_str, title])
    end
    
    # リンクを回して本文情報を取得
    link_info.sort!
    link_info.each do |elems|
      sleep SLEEP
      utime, link, time_str, title = elems
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
end # apple scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  apple = AppleScraper.new(logger, params, from, to)
  p apple.scrape()
end
