# Linda Worker

- deploy on Heroku
  - http://masuilab-linda-worker.herokuapp.com


![screenshot](http://shokai.org/archive/file/f0b5abc276612c61f427b249a035ebfb.png)

## Scripts

put into `scritps` directory.


## Run

### Run All Scripts

    % DEBUG=* npm start

### Run Specific Script

    % SCRIPT=light-notify npm start


## Logs

configure with env variable `DEBUG`

    % DEBUG=linda* npm start                     # print linda's read/write/take/watch operation
    % DEBUG=linda:worker* npm start              # print this app's status
    % DEBUG=linda:worker:light_notify npm start  # print `scripts/light_notify.coffee`
    % DEBUG=* npm start                          # print socket.io/engine.io/linda status
