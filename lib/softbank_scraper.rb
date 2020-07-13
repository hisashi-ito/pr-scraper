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
require 'extractcontent'
URL = "https://www.softbank.jp/corp/news/press/sbkk"

class SoftBankScraper < BaseScraper
  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
  end # initialize

  #= スクレイプ
  def scrape()
    times = []
    title_link = []
    html = request(URL) # URLは固定
    doc = parse(html)
    doc.xpath("//time[@class='corp-news-layout-info-01_date']").each do |x|
      utime = Time.strptime(x.text, "%Y年%m月%d日").to_i
      times.push(utime)
    end
    doc.xpath("//a[@class='corp-news-layout-info-01_link']").each do |x|
      title = x.text
      # 絶対URLへ変換
      link = URL + x.attribute("href").value
      title_link.push([title, link])
    end

    # 時刻情報,タイトル,リンク先の情報を取得
    # 工事中...    
    
  end

  #= リンク先のコンテンツ情報
  def link_body(url)
    html = request(url)
    body, title = ExtractContent.analyse(html)
    return [title, body]
  end
end # softbank scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/01/01").to_i
  to = Time::parse("2020/6/30").to_i
  softbank = SoftBankScraper.new(logger, params, from, to)
  softbank.scrape()
end
