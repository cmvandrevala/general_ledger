# General Ledger

## Background

This is a Sinatra backend for the [finance scripts](https://github.com/cmvandrevala/finance_scripts) frontend.

## Setup

After you clone this repo, you can use the following command to install all of the dependencies:

```
bundle install
```

Then, fill out the `config.yml.sample` file and rename it to `config.yml`. Be sure that you create the appropriate Postgres databases on your system. Finally, run the migrations on the database using the following commands:

```
ENV=production rake db:reset
ENV=production rake db:migrate
```

You can use `ENV=development` or `ENV=test` for the development and test environments.

## Run the Server

You can run the server using the following command:

```
ENV=production rake start
```

Again, you can switch the environment depending on your needs.
