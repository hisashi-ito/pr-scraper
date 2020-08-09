<p align="center">
<img src="images/pr-scraper-logo.png" width="250px">
</p>

#### 1. はじめに  
本リポジトリは「特定の企業のプレスリリースおよび、ニュースリリース」情報をスクレイプにより抽出するためのコードを管理するリポジトリとする。

#### 2. ディレクトリ構成 
* bin  
実行プログラム  
* images  
ロゴなどの画像ファイル  
* lib  
各種特定のサイドに対応するスクレイピング用ララスを準備

#### 3. ディレクトリ構成 
利用方法
```bash
$ cd bin
$ ruby ./pr_scraper.rb -s softbank -o softbank_pr.tsv -f 20200401 -t 20200630
```
* 引数一覧  
  - s: サイト名を指定、今は`softbank`のみ対応
  - o: 出力ファイル名
  - f: 取得対象の開始時間(YYYYMMDD)
  - t: 取得対象の終了期間(YYYYMMDD)
 
#### 4. 出力形式
```tsv
# 日付<TAB>タイトル<TAB>URL<TAB>本文
```
```tsv
20020年4月7日    テレメタリングプランを除くPHS向け料金プランなどの提供終了の延期について https://www.softbank.jp/corp/news/press/sbkk/2020/20200417_01/  テレメタリングプランを除くPHS向け料金プランなどの提供終了の延期について2020年4月17日ソフトバンク株式会社株式会社ウィルコム沖縄ソフトバンク株式会社および株式会社ウィルコム沖縄は、2020年7月31日に予定していたテレメタリングプランを除く&ldquo;ワイモバイル&rdquo;のPHS向け料金プランなどの提供の終了を、2021年1月31日まで延期します。今回の延期は、新型コロナウイルスの感染拡大の影響により携帯電話への移行手続きが困難になっている事情などを受けて、全国の医療機関をはじめとするお客さまから延期のご要望を多くいただいている状況に鑑みて決定したものです。対象となるお客さまには、個別にご案内します。提供の終了を延期する主な料金プランなどの詳細は、こちらをご覧ください。なお、&ldquo;ワイモバイル&rdquo;のテレメタリングプランは、2023年3月末をもって提供を終了します。ソフトバンク株式会社および株式会社ウィルコム沖縄は、今後もお客さまやビジネスパートナーの皆さま、社員の安全と安心を最優先として、社会情勢に応じた対応を行っていきます。SoftBankおよびソフトバンクの名称、ロゴは、日本国およびその他の国におけるソフトバンクグループ株式会社の登録商標または商標です。その他、このプレスリリースに記載されている会社名および製品・サービス名は、各社の登録商標または商標です。
```

#### 5.　PR抽出 対応企業
* ソフトバンク  
  https://www.softbank.jp/corp/news/press/all

* 百度JAPAN  
  https://www.baidu.jp/info/

* 楽天  
  https://corp.rakuten.co.jp/news/press/

* NTT docomo  
  https://www.nttdocomo.co.jp/info/news_release/year.html?year=2020  
  
* メルカリ  
   https://about.mercari.com/press/news/  
   
* DMM  
  https://dmm-corp.com/press/  

* LINE  
  https://linecorp.com/ja/pr/news/  
  
* CyberAgent  
  https://www.cyberagent.co.jp/news/press/
  
* Apple  
  https://www.apple.com/jp/newsroom/archive/
  
* Yahoo  
  https://about.yahoo.co.jp/pr/  

* Alibana  
  https://www.alibaba.co.jp/news/

* Microsoft  
  https://news.microsoft.com/ja-jp/category/press-releases/

* PRTIMES  
  PRTIMESを利用してkeyword を検索で以下の企業を検索する。
  * Amazon  
    https://prtimes.jp/topics/keywords/Aamazon  

  * Google  
    https://prtimes.jp/topics/keywords/Google  

  * KDDI  
    https://prtimes.jp/topics/keywords/KDDI

  * Facebook  
    https://prtimes.jp/topics/keywords/Facebook

