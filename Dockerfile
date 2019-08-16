FROM ruby

RUN mkdir -p /app
WORKDIR /app

COPY .docker/Gemfile .
COPY .docker/start.sh .

RUN bundle install

RUN useradd -u 1000 -M docker \
  && mkdir -p /messages/sqs \
  && chown docker /messages/sqs
USER docker

VOLUME /messages
EXPOSE 9494

ENV VIRTUAL_HOST sqs

# Note: We use thin, because webrick attempts to do a reverse dns lookup on every request
# which slows the service down big time.  There is a setting to override this, but sinatra
# does not allow server specific settings to be passed down.
CMD ./start.sh
