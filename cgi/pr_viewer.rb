#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【pr_viewer】
#
#  概要: Sinatraを用いたPress Release の情報を見れるようにするViewer
#
#  更新履歴:
#           2020.08.10 新規作成
#
require "bundler/setup"
require 'logger'
require 'cgi'
require 'logger'
require 'moji'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

# 表示件数
LIMIT = 200

$logger = Logger.new(STDERR)
$logger.level = Logger::INFO
# DB 初期化
$db = SQLite3::Database.new("./db/pr_table.sqlite3")

get '/pr' do
  # Topページは直近のデータをサイトに関係なく表示する
  sql = "select domain, display_time, title, link from pr_table order by unix_time desc limit #{LIMIT}"
  @ret = $db.execute(sql)
  erb :index
end

get '/pr/:domain' do
  # サービスのドメインを指定
  domain = params[:domain]
  # viewerを作成
  #erb :index
end
