# README

The purpose of this application is to store and display the on-duty schedule for a team.

## Local Development

To get started, run `make bootstrap` then `make` to run the development server.

`make bootstrap`
- Installs dependencies
- Creates database (drops if one exists)
- Runs migrations
- Seeds database

`make`
- Installs dependencies
- Runs development server

## Environments

- Heroku: https://supporthero-api.herokuapp.com

## API

For requests requiring authorization, you must pass an Authorization header with the request containing the bearer token provided when creating a session.

### Session

#### Creating a session

`POST /api/session`

- name _required_
- password _required_

Response:

```javascript
{
  "user": {
    "id": 1,
    "name": "Sherry"
  },
  "access_token": "m6pT6NWN0wvONyGRXzkk0g==$7gzBTy7jzB/1ZF87tbxFXQ==",
  "expires_in": 3599,
  "expires_at": "2016-01-04T10:39:10.888-08:00",
  "token_type": "bearer"
}
```

Example:

`curl -H "Content-Type: application/json" -X POST -d '{"name":"Sherry","password":"sherry123"}' https://supporthero-api.herokuapp.com/api/session`

### Schedule

#### Listing the schedules

`GET /api/schedules`

Response:

```javascript
[
  {
    "id": 2,
    "user_id": 2,
    "date": "2016-01-04",
    "user": {
      "name": "Boris"
    }
  }, ...
]
```

Example:

`curl https://supporthero-api.herokuapp.com/api/schedules`

#### Deleting a schedule

Deleting a schedule will result in it being assigned to the user with the least number of dates in the surrounding month.

`DELETE /api/schedules/10`

Response:

```javascript
{
  "id": 10,
  "user_id": 3,
  "date": "2016-01-14",
  "user": {
    "name": "Vicente"
  }
}
```

Example:

`curl -H "Authorization: Bearer m6pT6NWN0wvONyGRXzkk0g==$7gzBTy7jzB/1ZF87tbxFXQ==" -X DELETE http://localhost:3000/api/schedules/10`

#### Swapping a schedule

Swapping a schedule is accomplished by updating the date. If the date is already assigned, it will be swapped. If the requested date is un-assigned, it will be assigned to the user with least number of dates in the surrounding month.

`PATCH /api/schedules/2`

Response:

```javascript
{
  "id": 10,
  "user_id": 3,
  "date": "2016-01-14",
  "user": {
    "name": "Vicente"
  }
}
```

Example:

`curl -H "Content-Type: application/json" -H "Authorization: Bearer m6pT6NWN0wvONyGRXzkk0g==$7gzBTy7jzB/1ZF87tbxFXQ==" -X PUT -d '{"schedule": "date": "2016-01-14"}'  http://localhost:3000/api/schedules/10`

## Features

- Display today’s Support Hero.
- Display a single user’s schedule showing the days they are assigned to Support Hero
- Display the full schedule for all users in the current month.
- Users should be able to mark one of their days on duty as undoable
- The system should reschedule accordingly
- Should take into account weekends and California’s holidays.
- Users should be able to swap duty with another user’s specific day

## Resources

- A Ruby-based framework.
- UI of your choice: CLI, Web UI, ...
- Heavy emphasis pretending this is a system you would deploy
- OO and architecture best practices.

## Starting Order

```
['Sherry', 'Boris', 'Vicente', 'Matte', 'Jack', 'Sherry', 'Matte', 'Kevin', 'Kevin', 'Vicente', 'Zoe', 'Kevin', 'Matte', 'Zoe', 'Jay', 'Boris', 'Eadon', 'Sherry', 'Franky', 'Sherry', 'Matte', 'Franky', 'Franky', 'Kevin', 'Boris', 'Franky', 'Vicente', 'Luis', 'Eadon', 'Boris', 'Kevin', 'Matte', 'Jay', 'James', 'Kevin', 'Sherry', 'Sherry', 'Jack', 'Sherry', 'Jack']
```
