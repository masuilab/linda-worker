# Linda Worker

- deploy on Heroku
  - http://masuilab-linda-worker.herokuapp.com


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
    % DEBUG=linda:worker:light-notify npm start  # print `scripts/light-notify.coffee`
    % DEBUG=* npm start                          # print socket.io/engine.io/linda status
