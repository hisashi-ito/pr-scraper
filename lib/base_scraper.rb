#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【base_scraper】
#
# 概要:
#      プレスリリースの情報抽出基底クラス
#
# 更新履歴:
#           2020.07.13 新規作成
#
require "bundler/setup"
require 'logger'
require 'moji'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class BaseScraper
  # User Agent: Chrome/Mac を偽装
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3864.0 Safari/537.36'
  # テンプディレクトリ
  TMP_DIR = "/tmp"

  #= 初期化
  def initialize(logger, params)
    @logger = logger
    @params = params
    @logger.info(@params)
    # sleep 設定
    @fetch_interval = 0
    if @params.has_key?("fetch_interval")
      @fetch_interval = @params["fetch_interval"].to_i
    end
  end # initialize

  #= トリミング
  def trim(text)
    text = text.gsub(/\t+/," ")
    text = text.gsub(/\n+/,"")
    text = text.gsub(/\r+/,"")
    return text
  end

  #= 文字列の正規化
  def normalize(text)
    Moji.normalize_zen_han(text)
  end

  #= リクエスト
  def request(url)
    sleep(@fetch_interval)
    opt = {}
    opt['User-Agent'] = USER_AGENT
    html = nil
    begin
      open(url, opt) do |file|
        html = file.read
      end
    rescue
      @logger.error("ページの習得に失敗しました: #{url}")
      return nil
    end
    return html
  end

  #= parse
  def parse(html)
    doc = nil
    begin
      doc = Nokogiri::HTML.parse(html)
    rescue Exception => e
      # DOM のparse に失敗した場合はnilを返却
      @logger.error("パースに失敗しました: #{e.backtrace}")
    end
    return doc
  end

  #= スクレイピング
  def scrape(doc)
    raise "継承先のクラスで実装してください"
  end
end
