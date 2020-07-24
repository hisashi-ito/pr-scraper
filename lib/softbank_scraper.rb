#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【softbank_scraper】
#
#  概要: ソフトバンク株式会社 プレスリリース
#        https://www.softbank.jp/corp/news/press/sbkk/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.14 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class SoftBankScraper < BaseScraper
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
    title_link = []
    html = request(url) # URLは固定
    doc = parse(html)
    doc.xpath("//time[@class='corp-news-layout-info-01_date']").each do |x|
      utime = Time.strptime(x.text, "%Y年%m月%d日").to_i
      times.push(utime)
    end
    doc.xpath("//a[@class='corp-news-layout-info-01_link']").each do |x|
      title = x.text
      # URLへ変換
      link = x.attribute("href").value
      if link =~ (/^\//)
        link = "https://www.softbank.jp" + link
      end
      title_link.push([title, link])
    end

    # 時刻情報,タイトル,リンク先の情報を取得
    if times.size() != title_link.size()
      @logger.error("抽出した項目が不一致です。")
      exit
    end

    # 時間の昇順ソート
    times.sort!
    title_link.sort!
    
    times.each_with_index{|time, idx|
      sleep SLEEP
      # 時間が指定の範囲にあるかどう
      if @from <= time and time <= @to
        time_str = Time.at(time).strftime("%Y年%-m月%-d日")
        title, link = title_link[idx]
        ary = link_body(link)
        if ary == nil
          ret.push([time_str, title ,link, ""])
        else
          body = trim(ary[1])
          ret.push([time_str, title ,link, body])
        end
      end
    }
    return ret    
  end
  
  def scrape()
    return _scrape("https://www.softbank.jp/corp/news/press/all")
  end
end # softbank scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  softbank = SoftBankScraper.new(logger, params, from, to)
  p softbank.scrape()
end
