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

  def initialize(logger, params)
    @logger = logger
    @params = params
    @logger.info(@params)
    # sleep 設定
    @fetch_interval = @params["fetch_interval"].to_i
  end # initialize

  def trim(text)
    text = text.gsub(/\t+/," ")
    text = text.gsub(/\n+/,"")
    text = text.gsub(/\r+/,"")
    return text
  end

  def normalize(text)
    Moji.normalize_zen_han(text)
  end

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
end
