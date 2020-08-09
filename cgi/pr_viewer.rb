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

$logger = Logger.new(STDERR)
$logger.level = Logger::INFO

get '/pr' do
	# viewerを作成
	erb :index
end

get '/pr/:domain' do
	# サービスのドメインを指定
	domain = params[:domain]
	# viewerを作成
	#erb :index
end
