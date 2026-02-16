FROM ruby:3.2

# Chromium と必要なパッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    git \
    curl \
    nodejs \
    npm \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Selenium が chromium を見つけられるように環境変数を設定
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMIUM_FLAGS="--no-sandbox --headless=new --disable-dev-shm-usage"

WORKDIR /app

# Gemfile のコピーとbundle install（キャッシュ活用）
COPY Gemfile /app/Gemfile
RUN bundle install

# アプリケーションコードのコピー
COPY . /app

# npm でgentelella をインストール（COPY後に実行してnode_modulesが上書きされないようにする）
RUN cd /app/cgi && npm install

# 静的アセットのシンボリックリンク作成（gentelellaのCSS/JS）
# views/のERBテンプレートはカスタマイズ済みの実ファイルとしてCOPYされる
RUN rm -f /app/cgi/public/build /app/cgi/public/src /app/cgi/public/vendors \
    && ln -sf /app/cgi/node_modules/gentelella/build /app/cgi/public/build \
    && ln -sf /app/cgi/node_modules/gentelella/src /app/cgi/public/src \
    && ln -sf /app/cgi/node_modules/gentelella/vendors /app/cgi/public/vendors

# DBの初期化（存在しない場合）
RUN if [ ! -f /app/cgi/db/pr_table.sqlite3 ]; then \
      sqlite3 /app/cgi/db/pr_table.sqlite3 < /app/cgi/db/pr_table.sql; \
    fi

EXPOSE 4567

# デフォルトはWebビューワーを起動
CMD ["ruby", "/app/cgi/pr_viewer.rb"]
