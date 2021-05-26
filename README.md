# README

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

- Default `/endpoints` routes need to be protected from being overwritten/redefined/updated
- The database schema is different than the resulting json structure
- The reason is that endpoint and response have a 1:1 relation, putting them together potentially saves a join
- wrong methods to created endpoints return 404 according to the spec, but 405 Method Not Allowed is more appropriate
