# Attendance

## API Documentation

The documentation was created using Postman and its published [here](https://documenter.getpostman.com/view/1500109/SW7T6qt2?version=latest). 

## API request examples
To run it on postman using Heroku and an administrator account you can run it with Postman:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/62beb6160e993c5733de#?env%5BAttendance%20-%20Heroku%5D=W3sia2V5IjoiZW5kcG9pbnQiLCJ2YWx1ZSI6Imh0dHBzOi8vZmpzYW5kb3YtYXR0ZW5kYW5jZS1hcGkuaGVyb2t1YXBwLmNvbSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiZW1haWwiLCJ2YWx1ZSI6ImFkbWluQGV4YW1wbGUub3JnIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJwYXNzd29yZCIsInZhbHVlIjoiYWRtaW4xMjM0IiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJqd3RUb2tlbiIsInZhbHVlIjoiIiwiZW5hYmxlZCI6dHJ1ZX1d)

If you want to run it using a local server for development, you will need to execute `rake db:seed` to create the necessary data on your local database and change the postman environment variable `endpoint` to `http://localhost:3000` before executing requests.
