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
require 'extractcontent'
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
    def scrape()
        # リンク情報を抽出
        title_link = []
        html = request(URL_TOP)
        doc = parse(html)
        doc.xpath("//ul[@class='news_lists']/li").each do |x|
            # 時間時間取得
            x.xpath("a").each do |y|
                
            end
        end
    end
