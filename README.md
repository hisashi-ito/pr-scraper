<p align="center">
<img src="images/pr-scraper-logo.png" width="250px">
</p>

## 1. はじめに
本リポジトリは「特定の企業のプレスリリースおよび、ニュースリリース」情報をスクレイプにより抽出し、表示するCGIを管理するリポジトリとする。
本プログラムは、プレスリリース情報をWebから抽出するスクレイピングツールとそれをWebブラウザでプレスリリース情報を確認するCGIツールの２つに大別される。
以下に機能毎に説明する。

## 2. Docker による起動（推奨）

Dockerを利用することで、環境構築不要ですぐに利用できる。

### 前提条件
- Docker および Docker Compose がインストールされていること

### Web Applicationの起動
```bash
$ docker compose up web
```
`http://localhost:4567/pr` でアプリケーションへアクセスできる。

### スクレイピングの実行
```bash
# 例: ソフトバンクのプレスリリースを取得
$ docker compose run --rm --profile scraper scraper \
    -s softbank -o /app/data/softbank_pr.tsv -f 20240101 -t 20241231
```

### DBへのデータ登録
スクレイピングで取得したTSVデータをDBに登録する。
```bash
$ docker compose exec web ruby /app/cgi/db/update.rb \
    -d /app/cgi/db/pr_table.sqlite3 -i /app/data/softbank_pr.tsv
```

### コンテナの停止
```bash
$ docker compose down
```

## 3. スクレイピング・ツール
スクレイピングツールは、主要IT企業のプレスリリースを企業毎に抽出し、`tsv`形式のファイルを出力する機能を提供する。

* 利用方法（ローカル実行の場合）
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

## 4.  Web Application（ローカル実行）
Docker を使わずにローカルで実行する場合の手順を以下に示す。

### 前提条件
- Ruby 3.2 以上
- Bundler
- SQLite3
- Node.js / npm
- Chromium または Google Chrome（スクレイピング機能を使用する場合）

### セットアップ
```bash
# gem のインストール
$ bundle install

# gentelella のインストール
$ cd cgi && npm install
```

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
```bash
$ cd cgi
$ ruby ./pr_viewer.rb
```
デフォルトでは`localhost:4567/pr`でアプリケーションへアクセスできる。
