FROM nginx:alpine

# デフォルトで用意される80番ポートをlistenするserverコンテキストを持った
# default.confファイルは不要なので削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
# ADD nginx.conf /etc/nginx/conf.d/myapp.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Nginxをフォアグラウンド化して起動(-g 'daemon off;')。
# デフォルトではデーモンで起動してしまう。フォアグラウンドで起動しないとコンテナが止まってしまう
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
