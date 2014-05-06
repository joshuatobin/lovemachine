lovemachine
===========


The love machine is a heroku app for companies to help employees send peer to peer recognition. The love machine will be backed by a heroku postgresql database keeping mappings of username, email and recognition messages between users. 


The love machine is a concept originally created by [Phillip Rosedale](http://en.wikipedia.org/wiki/Philip_Rosedale) during the early days of [Linden Lab](lindenlab.com). 

## Deploy

```bash
$ git push heroku master
$ heroku config:set LOVEMACHINE_EMAIL_PASSWORD=<PASSWORD>
$ heroku config:set LOVEMACHINE_EMAIL_USERNAME=<USERNAME>
$ heroku run bundle exec rake db:migrate
$ heroku run bin/console 
k = APIkey.create()
k.key
$ heroku restart # Restart the dyno to pick up the model changes

If using gmail for SMTP you'll need to [unlock the account for clients connecting from EC2](http://www.google.com/accounts/DisplayUnlockCaptcha)
```

## TODO:
* Force SSL
* Migrate app to use [Pliny](https://github.com/interagent/pliny)
* Update app to use JSON schema


## User
A user object contains a users name, email address. 

### Atributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr> 
    <tr>
    <td><strong>email</strong></td>
    <td><em>string</em></td>
    <td>Email address</td>
    <td>john@lovemachine.com</td>
  </tr>
</table>

### User Create
Create a new user

```
POST /user
```

#### Required Parameters

<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr> 
    <tr>
    <td><strong>email</strong></td>
    <td><em>string</em></td>
    <td>Email address</td>
    <td>john@lovemachine.com</td>
  </tr>
</table>

#### Curl Example

```term
$ curl -n -X POST https://lovemachine-api.domain.com/user \
-H "Content-Type: application/json" \
-d '{"email": "jdoe@lovemachine.com"}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```
{
  "username": "jdoe",
  "email": "jdoe@lovemachine.com"
}
```

## User Info
Get info for existing user.

```
GET /user/{username}
```

#### Curl Example

```term
curl -n -X GET https://lovemachine-api.domain.com/user/$username
```

#### Response Example
```
HTTP/1.1 200 OK
```
```
{
  "username": "jdoe",
  "email": "jdoe@lovemachine.com"
}
```

## Users List
List all users info

```
GET /users
```

#### Curl Example

```term
curl -n -X GET https://lovemachine-api.domain.com/users
```

#### Response Example
```
HTTP/1.1 200 OK
```
```
{
  "username": "jdoe",
  "email": "jdoe@lovemachine.com"
},
{
  "username": "james",
  "email": "james@lovemachine.com"
}
```

## User Delete
Delete and existing user

```
DELETE /user/{username}
```
#### Curl Example

```term
curl -n -X DELETE https://lovemachine-api.domain.com/user/$username
```

#### Response Example
```
HTTP/1.1 200 OK
```
```
{
  "username": "jdoe",
  "email": "jdoe@lovemachine.com"
}
```

## Love
Send a recognition message to a user.

### Attributes

<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr> 
    <tr>
    <td><strong>to</strong></td>
    <td><em>string</em></td>
    <td>Email address</td>
    <td>jdoe@lovemachine.com</td>
  </tr>
  </tr> 
    <tr>
    <td><strong>message</strong></td>
    <td><em>string</em></td>
    <td>A recognition message from one person to another</td>
    <td>Thanks for shipping the new API</td>
  </tr>
  </tr> 
    <tr>
    <td><strong>created_at</strong></td>
    <td><em>date-time</em></td>
    <td>When the message was sent</td>
    <td>"2012-01-01T12:00:00Z"</td>
  </tr>
</table>

## Love Create
Create a new love message

```
POST /love
```

#### Required Parameters

<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr> 
    <tr>
    <td><strong>to</strong></td>
    <td><em>string</em></td>
    <td>Email address</td>
    <td>jdoe@lovemachine.com</td>
  </tr>
  </tr> 
    <tr>
    <td><strong>message</strong></td>
    <td><em>string</em></td>
    <td> recognition message from one person to another</td>
    <td>Thanks for shipping the new API</td>
  </tr>
  </tr> 
    <tr>
    <td><strong>created_at</strong></td>
    <td><em>date-time</em></td>
    <td>When the message was sent</td>
    <td>"2012-01-01T12:00:00Z"</td>
  </tr>
</table>

#### Curl Example

```term
$ curl -n -X POST https://lovemachine-api.domain.com/love \
-H "Content-Type: application/json" \
-d '{"to": "jdoe@lovemachine.com", "message": "Thanks for shipping the new API", "created_at": "2012-01-01T12:00:00Z"}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```
{
  "to": "jdoe@lovemachine.com",
  "message": "Thanks for shipping the new API",
  "created_at": "2012-01-01T12:00:00Z"
}
```

## Love List
List all the love sent


```
GET /love
```

#### Curl Example

```term
curl -n -X GET https://lovemachine-api.domain.com/love
```

#### Response Example
```
HTTP/1.1 200 OK
```
```
{
  "to": "jdoe@lovemachine.com",
  "from": "john@lovemachine.com",
  "created_at": "2012-01-01T12:00:00Z",
  "message": "Thanks for shipping the new API"
}
```
 ### Dev setup

```bash
dropdb lovemachine
rake create_db
rake test all

bundle exec bin/console
irb(main):001:0> APIKey.create()
```