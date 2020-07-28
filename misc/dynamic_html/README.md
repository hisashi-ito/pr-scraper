## CentOS でChrome ドライバを利用する方法
* https://qiita.com/sakuraya/items/8d415e154ce60a83d63d

```shell
$ sudo emacs /etc/yum.repos.d/google-chrome.repo
```
```shell
/etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
```
```shell
$ sudo yum update
```
```shell
$ sudo yum install google-chrome-stable
$ google-chrome --version
Google Chrome 84.0.4147.105
```
### ChromeDriverのインストール
```shell
$ wget https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip
$ unzip ./chromedriver_linux64.zip
$ sudo mv chromedriver /usr/local/bin/
$ sudo chmod 755 /usr/local/bin/chromedriver
$ chromedriver --version
ChromeDriver 84.0.4147.30 (48b3e868b4cc0aa7e8149519690b6f6949e110a8-refs/branch-heads/4147@{#310})
```
### 依存ライブラリ
```shell
$ sudo yum install -y openssl-devel readline-devel zlib-devel 
```
### gem
```shell
$ gem install selenium-webdriver
```
### 日本語フォント
定番なのでこれをいれておくとよい。
```shell
$ sudo yum install -y ipa-gothic-fonts ipa-mincho-fonts ipa-pgothic-fonts ipa-pmincho-fonts
```
