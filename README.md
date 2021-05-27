# ECHO Server

This is an implementation of a configurable "Echo" server, where clients can define endpoints that respond according to their specification.

## Requirements

The server is written in [Ruby 3](https://github.com/ruby/ruby) and [Ruby on Rails 6](https://github.com/rails/rails). You will also need the [Ruby Bundler](https://bundler.io/) to build the server.

## Setup

With `ruby` and `bundle` installed on your system you can build the application locally using

```sh
$ bundle install
```

You will then need to run initial database migrations to setup the application:

```sh
$ rails db:migrate
```

By default the application uses a local `sqlite3` database.

Rails comes with a local development server. To run the application with it use

```sh
$ rails server
```

which starts the application and lets it listen on port `3000`. Run `rails server --help` for additional configuration options of the local server.

You can also run the test suite with

```sh
$ bundle exec rspec
```

## Basic Functionality

With the server running you can make HTTP requests to it in order to create echo endpoints and call them afterwards. For demonstration purposes I'll use [httpie](https://httpie.io/) as a client.

### Create a new endpoint

The echo server provides one resource endpoint `/endpoints` that allows you to list, show, create and update endpoints. The server handles JSON payloads in the [json:api](https://jsonapi.org/) format. A typical payload for an endpoint definition might look like this:

```json
{
  "data": {
    "type": "endpoints",
    "attributes": {
      "verb": "GET",
      "path": "/greeting",
      "response": {
        "code": 200,
        "headers": {
          "Cache-Control": "max-age=3600",
          "Last-Modified": "Thu, 27 May 2021 14:00:00 GMT"
        },
        "body": "\"{ \"message\": \"Hello, world\" }\""
      }
    }
  }
}
```

You can find the above definition in the `greeting_endpoint.json`. To use it and create an endpoint using httpie, run this command:

```sh
$ http POST http://localhost:3000/endpoints < greeting_endpoint.json

HTTP/1.1 201 Created
[...]
{
    "data": {
        "attributes": {
            "path": "/greeting",
            "response": {
                "body": "\"{ \"message\": \"Hello, world\" }\"",
                "code": 200,
                "headers": {
                    "Cache-Control": "max-age=3600",
                    "Last-Modified": "Thu, 27 May 2021 14:00:00 GMT"
                }
            },
            "verb": "GET"
        },
        "id": 1,
        "type": "endpoints"
    }
}
```

which should return something similar to

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## Notes / TODOs

- Default `/endpoints` routes might need to be protected from being overwritten/redefined/updated
- The database schema is different than the resulting json structure
- The reason is that endpoint and response have a 1:1 relation, putting them together potentially saves a join
- Input validation for body and path is probably needed
- path+method combinations might need to be unique
- response body does not usually conform to a specific mimetype. I probably shouldn't assume JSON
