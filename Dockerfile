FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /body_composition_tracker

WORKDIR /body_composition_tracker

COPY Gemfile /body_composition_tracker/Gemfile

COPY Gemfile.lock /body_composition_tracker/Gemfile.lock

RUN bundle install

COPY . /body_composition_tracker

CMD ["puma"]
