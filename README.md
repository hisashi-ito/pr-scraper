<p align="center">
<img src="images/pr-scraper-logo.png" width="250px">
</p>

## 1. はじめに  
本リポジトリは「特定の企業のプレスリリースおよび、ニュースリリース」情報をスクレイプにより抽出し、表示するCGIを管理するリポジトリとする。
本プログラムは、プレスリリース情報をWebから抽出するスクレイピングツールとそれをWebブラウザでプレスリリース情報を確認するCGIツールの２つに大別される。
以下に機能毎に説明する。

## 2. スクレイピング・ツール
スクレイピングツールは、主要IT企業のプレスリリースを企業毎に抽出し、`tsv`形式のファイルを出力する機能を提供する。

* 利用方法
  ```bash
  $ cd bin
  $ ruby ./pr_scraper.rb -s softbank -o softbank_pr.tsv -f 20200401 -t 20200630
  ```

* 引数一覧  
  - s: サイト名を指定
  - o: 出力ファイル名
  - f: 取得対象の開始時間(YYYYMMDD)
  - t: 取得対象の終了期間(YYYYMMDD)
 
  今回は `PR抽出 対応企業`の企業名(括弧内の企業名)を入れることで抽出できる。

* 出力形式
  ```tsv
  # 日付<TAB>タイトル<TAB>URL<TAB>本文
  ```

  ```tsv
  20020年4月7日    テレメタリングプランを除くPHS向け料金プランなどの提供終了の延期について https://www.softbank.jp/corp/news/press/sbkk/2020/20200417_01/  テレメタリングプランを除くPHS向け料金プランなどの提供終了の延期について2020年4月17日ソフトバンク株式会社株式会社ウィルコム沖縄ソフトバンク株式会社および株式会社ウィルコム沖縄は、2020年7月31日に予定していたテレメタリングプランを除く&ldquo;ワイモバイル&rdquo;のPHS向け料金プランなどの提供の終了を、2021年1月31日まで延期します。今回の延期は、新型コロナウイルスの感染拡大の影響により携帯電話への移行手続きが困難になっている事情などを受けて、全国の医療機関をはじめとするお客さまから延期のご要望を多くいただいている状況に鑑みて決定したものです。対象となるお客さまには、個別にご案内します。提供の終了を延期する主な料金プランなどの詳細は、こちらをご覧ください。なお、&ldquo;ワイモバイル&rdquo;のテレメタリングプランは、2023年3月末をもって提供を終了します。ソフトバンク株式会社および株式会社ウィルコム沖縄は、今後もお客さまやビジネスパートナーの皆さま、社員の安全と安心を最優先として、社会情勢に応じた対応を行っていきます。SoftBankおよびソフトバンクの名称、ロゴは、日本国およびその他の国におけるソフトバンクグループ株式会社の登録商標または商標です。その他、このプレスリリースに記載されている会社名および製品・サービス名は、各社の登録商標または商標です。
  ```
* PR抽出 対応企業
  * ソフトバンク(softbank)  
  https://www.softbank.jp/corp/news/press/all

  * 百度JAPAN(baidu)  
  https://www.baidu.jp/info/

  * 楽天(rakuten)  
  https://corp.rakuten.co.jp/news/press/

  * NTT docomo(docomo)  
  https://www.nttdocomo.co.jp/info/news_release/year.html?year=2020  
  
  * メルカリ(mercari)  
   https://about.mercari.com/press/news/  
   
  * DMM(dmm)  
  https://dmm-corp.com/press/  

  * LINE(line)  
  https://linecorp.com/ja/pr/news/  
  
  * CyberAgent(cyberagent)  
  https://www.cyberagent.co.jp/news/press/
  
  * Apple(apple)  
  https://www.apple.com/jp/newsroom/archive/
  
  * Yahoo(yahoo)  
  https://about.yahoo.co.jp/pr/  

  * Alibaba(alibaba)  
  https://www.alibaba.co.jp/news/

  * Microsoft(microsoft)  
  https://news.microsoft.com/ja-jp/category/press-releases/

  * PRTIMES  
    PRTIMESを利用してkeyword を検索で以下の企業を検索する。
    * Amazon(amazon)  
      https://prtimes.jp/topics/keywords/Amazon  

    * Google(google)  
      https://prtimes.jp/topics/keywords/Google  

    * KDDI(kddi)  
      https://prtimes.jp/topics/keywords/KDDI

    * Facebook(facebook)  
      https://prtimes.jp/topics/keywords/Facebook

## 3.  Web Application
web application を作成するためには抽出したPressReleases情報からDBを作成する。DBは`sqlite3`を利用する。作成方法は以下のように作成する。
ここでは、事前に`sqlite3`が事前にインストールされていることを想定とする。Macでは事前にインストールされている。

### DBの構築
* tableの作成  
  ```bash
  $ sqlite3 ./pr_table.sqlite3 < ./pr_table.sql
  ```
* データの登録
  ```bash
  $ cd cgi/db
  # DBを作成する
  $ ./mk_table.sh
  # Dataを登録する
  $ sqlite3 ./pr_table.sqlite3
  sqlite> .separator "\t"
  sqlite> .import pr.tsv pr_table
  ```
### Web Applicationの起動  
web application の構築には`sinatra` を利用している。application の起動は
```
$ cd cgi
$ ruby ./pr_viewer.rb
[2020-08-10 20:14:39] INFO  WEBrick 1.4.2
[2020-08-10 20:14:39] INFO  ruby 2.6.3 (2019-04-16) [universal.x86_64-darwin19]
== Sinatra (v2.0.8.1) has taken the stage on 4567 for development with backup from WEBrick
[2020-08-10 20:14:39] INFO  WEBrick::HTTPServer#start: pid=46630 port=4567
```
デフォルトでは`localhost:4567/pr`でアプリケーションへアクセスできる。

