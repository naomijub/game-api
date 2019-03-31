# GameApi

An API to save and retrieve game data

## Requirements

* Docker
* Docker-Compose
* Elixir (on container)
* MongoDB (on container)

### Setup

* Before running the app run `make setup`

## Available Queries and Mutations
- Run api
- Go to your browser on [http://localhost:4000/api/graphiql](http://localhost:4000/api/graphiql)

## Running

To run, just start the server:

  `make run-local`

Once the project is up and running, go to http://localhost:4000/api/graphiql from your browser. You can also make a post to this endpoint with the following structure:

```
{
  "query" => "query {gameById(id: "5c866e83a1b087000186a669")
                      {
                        name
                        description
                        id
                        category
                        rating
                      }}"
}
```

## Testing

To run tests type:

  `make test`

## Learn more on Elixir

  * Official website: https://elixir-lang.org/docs.html
  * Guides: https://joyofelixir.com/toc.html
  * Docs: https://hexdocs.pm/elixir/
  * Source: https://github.com/elixir-lang/elixir

## Learn more on Phoenix

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## GraphQL on Elixir

* Guide: https://www.howtographql.com/graphql-elixir/1-getting-started/
* Docs: https://hexdocs.pm/absinthe/overview.html

#TODO
- [] Travis.ci
- [] Paginate responses
- [] Authorization
- [] Heroku
