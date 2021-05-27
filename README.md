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

## Usage

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
$ http POST localhost:3000/endpoints < greeting_endpoint.json

HTTP/1.1 201 Created
[...]
{
    "data": {
        "attributes": {
            "path": "/greeting",
            "response": {
                "body": "{ \"message\": \"Hello, world\" }",
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

The response will give you the endpoint `id` which you can use to refer to this specific endpoint later.

### Call your endpoint

After creation you can call your defined endpoint:

```
$ http localhost:3000/greeting

HTTP/1.1 200 OK
[...]
{
    "message": "Hello, world"
}

```

## Endpoint Documentation

### GET /endpoints

Returns a list of created endpoints.

```
GET /endpoints
Accept: application/vnd.api+json

200 OK
Content-Type: application/vnd.api+json
{
    "data": [
        {
            "attributes": {
                "path": "/greeting",
                "response": {
                    "body": "{ \"message\": \"Hello, world\" }",
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
    ]
}
```

### POST /endpoints

Creates a new endpoint.

```
POST /endpoints
Accept: application/vnd.api+json
Content-Type: application/vnd.api+json
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
        "body": "{ \"message\": \"Hello, world\" }"
      }
    }
  }
}

201 Created
Content-Type: application/vnd.api+json
{
    "data": {
        "attributes": {
            "path": "/greeting",
            "response": {
                "body": "{ \"message\": \"Hello, world\" }",
                "code": 200,
                "headers": {
                    "Cache-Control": "max-age=3600",
                    "Last-Modified": "Thu, 27 May 2021 14:00:00 GMT"
                }
            },
            "verb": "GET"
        },
        "id": 3,
        "type": "endpoints"
    }
}

```

### PATCH /endpoints/:id

Updates the endpoint with the specified `id`

```
PATCH /endpoints/3
Accept: application/vnd.api+json
Content-Type: application/vnd.api+json
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
        "body": "{ \"message\": \"Hello, world\" }"
      }
    }
  }
}

200 OK
Content-Type: application/vnd.api+json
{
    "data": {
        "attributes": {
            "path": "/greeting",
            "response": {
                "body": "{ \"message\": \"Hello, world\" }",
                "code": 200,
                "headers": {
                    "Cache-Control": "max-age=3600",
                    "Last-Modified": "Thu, 27 May 2021 14:00:00 GMT"
                }
            },
            "verb": "GET"
        },
        "id": 3,
        "type": "endpoints"
    }
}

```

### DELETE /endpoints/:id

Deletes the endpoint with the specified `id`

```
DELETE /endpoints/1

204 No Content
```

## Errors and Validation

The server implements some validation for endpoint input:

- HTTP methods are only allowed to be one of 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'PATCH'
- Paths are restricted to alphanumerical characters

When validation fails or when endpoints can not be found, the server responds with an error message, for example:

```
GET /endpoints/10
Accept: application/vnd.api+json

404 Not Found
Content-Type: application/vnd.api+json
{
    "errors": [
        {
            "code": "not_found",
            "detail": "Couldn't find Endpoint with 'id'=10"
        }
    ]
}
```

## Possible improvements

- Default `/endpoints` routes might need to be protected from being overwritten. This should not be a problem because the route definition for them comes BEFORE the custom routes, but returning something like `409 Conflict` for those routes would still be a good idea.
- It is currently possible to create multiple endpoints with the same path and http method combination, leading to those endpoints potentially being inaccessible. A uniqueness constraint for Path + Method should fix this
- When accessing an existing endpoint path with a different HTTP method the server will respond with a 404 Not Found. Instead, it could respond with 405 Method Not Allowed and add the `Allow` response header with the method(s) currently supported
- Error messages, especially for endpoint path/method combinations not found, can be improved. They currently return the ActiveRecord error message which indicates that the backend uses some SQL-like technology, which is not ideal from a security perspective.
- json:api provides some good opportunities to work with paging and filtering, which could come in handy when creating lots of endpoint definitions.
