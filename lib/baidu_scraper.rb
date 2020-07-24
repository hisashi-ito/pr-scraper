#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【baidu_scraper】
#
#  概要: 百度JAPAN プレスリリース
#        https://www.baidu.jp/info/
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

class BaiduScraper < BaseScraper
  # トップページ
  URL_TOP = "https://www.baidu.jp/info/"
  # トップ以降のページ
  URL = "https://www.baidu.jp/info/page/"

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
    doc.xpath("//ul[@class='news_lists']/li/a").each do |x|
      utime = nil
      time_str = nil
      title = nil
      link = x.attribute("href").value
      x.xpath("p[@class='date']").each do |y|
        date = y.text
        date = date.gsub('報道発表', '')
        date = date.gsub('百度本社', '')
        utime = Time.strptime(date, "%Y.%m.%d").to_i
        time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
      end
      x.xpath("p[@class='txt']").each do |y|
        title = y.text
      end
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
    # 10ページまで一応ページング
    2.upto(10){|x|
      url = "#{URL}#{x}"
      _ret = _scrape(url)
      break if _ret.size == 0
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
  baidu = BaiduScraper.new(logger, params, from, to)
  p baidu.scrape()
end
