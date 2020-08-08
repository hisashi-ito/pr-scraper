#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【alibaba_scraper】
#
#  概要: Alibaba プレスリリース
#        https://www.alibaba.co.jp/news/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.08.8 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class AlibabaScraper < BaseScraper
  URL_TOP = "https://www.alibaba.co.jp/news/"

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
    doc.xpath("//div[@class='news-conts js-tab-conts is-active']/dl[@class!='recruit']").each do |x|
      time_str = x.xpath("dt").text
      utime = Time.strptime(time_str,'%Y.%m.%d').to_i
      time_str = Time.at(utime).strftime("%Y年%-m月%-d日")
      title = x.xpath("*[@class='c-news-text']").text
      link = x.xpath("*[@class='c-news-text']/a").attribute("href").value
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
    return _scrape(URL_TOP)
  end # scrape

end # alibaba

if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  alibaba = AlibabaScraper.new(logger, params, from, to)
  p alibaba.scrape()
end
