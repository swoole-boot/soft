FROM  centos
MAINTAINER jianghaiqiang jhq0113@163.com

#安装依赖
RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel libxslt-devel -y gd gd-devel pcre pcre-devel vim wget curl-devel

#创建用户
RUN groupadd www
RUN useradd www -g www -s /sbin/nologin

#拷贝依赖包
COPY php-7.2.22.tar.gz /usr/local/src
COPY swoole-4.4.5.tar.gz /usr/local/src
COPY nginx-1.12.2.tar.gz /usr/local/src
COPY pcre-8.43.tar.gz /usr/local/src
COPY yaf-3.0.8.tgz /usr/local/src
COPY igbinary-3.0.1.tgz /usr/local/src
COPY msgpack-2.0.3.tgz /usr/local/src
COPY redis-5.0.2.tgz /usr/local/src
COPY yac-2.0.2.tgz /usr/local/src
COPY SeasLog-2.0.2.tgz /usr/local/src

#解压依赖包
RUN cd /usr/local/src && tar xzvf php-7.2.22.tar.gz && tar xzvf swoole-4.4.5.tar.gz && tar xzvf nginx-1.12.2.tar.gz && tar xzvf pcre-8.43.tar.gz && tar xzvf yaf-3.0.8.tgz && tar xzvf igbinary-3.0.1.tgz && tar xzvf msgpack-2.0.3.tgz && tar xzvf redis-5.0.2.tgz && tar xzvf yac-2.0.2.tgz && tar xzvf yaconf-1.0.7.tgz && tar xzvf SeasLog-2.0.2.tgz

#安装php
RUN cd /usr/local/src/php-7.2.22 && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-gd --with-iconv --with-zlib --with-curl --with-pdo-mysql --with-png-dir --with-jpeg-dir --with-freetype-dir --with-fpm-user=www --with-fpm-group=www --with-gettext --with-openssl --enable-xml --enable-bcmath --enable-fpm --enable-mbstring --enable-sockets --enable-session --with-gettext
RUN cd /usr/local/src/php-7.2.22/ && make && make install
RUN ln -s /usr/local/php/bin/php /usr/bin/php && ln -s /usr/local/php/bin/phpize /usr/bin/phpize

#拷贝php配置文件
COPY php.ini /usr/local/php/etc/
COPY php-fpm.conf /usr/local/php/etc/
COPY www.conf /usr/local/php/etc/php-fpm.d/

#php配置做软连
RUN rm -rf /etc/php.ini
RUN ln -s /usr/local/php/etc/php.ini /etc/php.ini
RUN ln -s /usr/local/php/etc/php-fpm.conf /etc/php-fpm.conf

#安装php扩展
RUN cd /usr/local/src/swoole-src-4.4.5 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/yaf-3.0.8 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/igbinary-3.0.1 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/msgpack-2.0.3 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/yac-2.0.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/yaconf-1.0.7 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
RUN cd /usr/local/src/SeasLog-2.0.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install

#安装nginx
RUN cd /usr/local/src/pcre-8.43 && ./configure && make && make install
RUN cd /usr/local/src/nginx-1.12.2 && ./configure --prefix=/usr/local/nginx --with-pcre=/usr/local/src/pcre-8.43 --with-http_stub_status_module --user=www --group=www --with-http_ssl_module && make && make install
