# Linda Worker Masuilab

generated with [generator-linda](https://npmjs.org/package/generator-linda) v0.2.6

[![Build Status](https://travis-ci.org/masuilab/linda-worker.svg?branch=master)](https://travis-ci.org/masuilab/linda-worker)

- deploy on Heroku
  - http://masuilab-linda-worker.herokuapp.com


![screenshot](http://shokai.org/archive/file/f0b5abc276612c61f427b249a035ebfb.png)

## Config

    % heroku config:set YO_DOOR_TOKEN=token


## Scripts

put into `scritps` directory.


## Run

### Run All Scripts

    % npm start

### Run Specific Script

    % SCRIPT=light-notify npm start
    % SCRIPT=*notify npm start


## Logs

configure with env variable `DEBUG`

    % DEBUG=linda* npm start                     # print linda's read/write/take/watch operation
    % DEBUG=linda:worker* npm start              # print this app's status
    % DEBUG=linda:worker:light_notify npm start  # print `scripts/light_notify.coffee`
    % DEBUG=* npm start                          # print socket.io/engine.io/linda status


## Test

    % npm i grunt-cli -g

    % npm test
    # or
    % grunt