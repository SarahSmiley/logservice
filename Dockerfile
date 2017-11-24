FROM ruby:2.3.1
RUN apt-get update -qq && \
	apt-get --no-install-recommends install -y build-essential \
	python-dev \
	nginx-extras \
	pkg-config \
	cmake \
	libxrender1 \
	libmysqlclient-dev \
	ncurses-dev \
	gettext \
	flex \
	bison \
	autoconf \
	binutils-doc \
	nginx \
	nodejs 
RUN mkdir -p /srv/www/log_service
WORKDIR /srv/www/log_service
CMD [ "bash" ]
COPY Gemfile Gemfile.lock /srv/www/log_service/
RUN bundle install
ENV RAILS_ENV staging
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
ADD . /srv/www/log_service
RUN chmod +x /srv/www/log_service/server.sh
EXPOSE 3000
CMD ["./server.sh"]