# DataBase (sqlite3)
cgiのデーターベースは `sqlite3`を利用する。Macではすでに保存されているので特にインストールする必要はない。ubuntsの場合は以下でインストール可能。

```bash
$ sudo apt-get install -y sqlite3
```

## テーブル定義

| 項目 | 型| 説明 |
| :---         |     :---:      |          ---: |
| DOMAIN   | TEXT   | ドメイン名   |
| UNIX_TIME   | INTEGER   | UNIX時間  |
| DISPLAY_TIME  | TEXT  | 表示時間 |
| TITLE | TEXT |タイトル|
| LINK | TEXT |リンク|
| BODY | TEXT |ニュースの本文|

### テンプレート・インストール  
https://github.com/ColorlibHQ/gentelella　　
```bash
$ npm install gentelella --save
```

### DBの構築
* tableの作成  
```bash
$ sqlite3 ./pr_table.sqlite3 < ./pr_table.sql
```
* データの登録
```bash
$ sqlite3 ./pr_table.sqlite3
sqlite> .separator "\t"
sqlite> .import pr.tsv pr_table
```
