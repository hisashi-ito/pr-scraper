#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'time'

# ドメインを設定
site = ARGV[0]

while line = STDIN.gets
  begin
    elems = line.chomp.split("\t")
    day, title, url, body = elems
    utime = Time.strptime(day, "%Y年%m月%d日").to_i
    puts("#{site}\t#{utime}\t#{day}\t#{title}\t#{url}\t#{body}")
  rescue
    next
  end
end
