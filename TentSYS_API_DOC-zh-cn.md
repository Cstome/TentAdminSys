# Tent SYS API v3 Document

## Basic Description

### Request Config

Headers: ` Content-Type: application/json `

Allowed Methods: ` POST/GET/PUT/DELETE`

### Request Address

#### Base URL:

> Development URL(Example) : http://localhost/api/v3
>

### Authorization & Access Token

While Some API may required an access token, it depend on each API defined. For the details about get access token, please see *1.1 Log in*.

Access token can send by those ways:

1. Authorization header (recommend) :

   ```
   Authorization: Bearer {access_token}
   ```

   Due to `Bearer` is default access token type, so `Bearer` could be omit.

   ```
   Authorization: {access_token}
   ```

2. Form-Encoded Body Parameter (Unavailable)

   ```
   POST /resource HTTP/1.1
   Host: server.example.com
   Content-Type: application/x-www-form-urlencoded
   
   access_token=mF_9.B5f-4.1JqM
   ```

3. URI Query Parameter (Unavailable)
   ```
   GET /resource?access_token={access_token}
   ```


### URL Format

GET `{baseUrl}/resource` resource list.

POST`{baseUrl}/resource` create a new resource.

GET `{baseUrl}/resource/:id` get resource details by id.

PUT `{baseUrl}/resource/:id` update resource by id.

DELETE `{baseUrl}/resource/:id` delete resource by id.

### Reserved Parameters

#### Commons

`id` The id of the resource item.

`status` Select the status of the resource item, `-1` for deleted, `0` for disable, `1` for normal.

`create_time` `update_time` Select the create time or update time of the resource item.

#### list

`page` The page number , start with 1.

`pageSize` Defined the response item count per page, default is 10.

#### How to sent parameters?

1. Via URL query string:

```
{url}?status=1&create_time=1591314227
```

2. Via request body:

```json
{
    "status": 1,
    "create_time": 1591314227
}
```



## 1 Authorization

### 1.1 Sign up account

```
POST {baseUrl}/oauth/signup
```

### 1.2 Get access token

Tent API system authorize access permission base [Oauth 2.0](https://tools.ietf.org/html/rfc6749) , it enables clients to access protected resources by obtaining an access token. 

To request an access token, the client obtains authorization from the resource owner.  The authorization is expressed in the form of an authorization grant, which the client uses to request the access token.  OAuth defines four grant types: authorization code, implicit, resource owner password credentials, and client credentials.  It also provides an extension mechanism for defining additional grant types.

#### 1.2.1 Password Credentials Grant

_This grant type for login._

##### Using GET method

```
GET {baseUrl}/oauth/token?client_id={client_id}&grant_type=password&scope=read&username=15913142273&password=111111 
```

##### Using POST method (Recommend)

```
POST {baseUrl}/oauth/token
```

###### Body

```json
{
    "client_id": "{client_id}",
    "grant_type": "password",
    "scope": "{read}",
    "username": "{username}",
    "password": "{password}"
}
```



##### Params

| Params                  | Type   | Required | Default | Option                                           |
| ----------------------- | ------ | -------- | ------- | ------------------------------------------------ |
| client_id               | string | No       | _None_  | pcclient, iosclient, ...                         |
| grant_type              | string | Yes      |         | MUST be `password` in Password Credentials Grant |
| scope                   | string | No       | read    |                                                  |
| username\|mobile\|email | string | Yes      |         | username\|mobile\|email 至少包含一个             |
| password                | string | Yes      |         | Password                                         |

##### Response

```json
{
    "access_token": "1db3191206e94872cdccf5fc0468109dd073058a",
    "token_type": "Bearer",
    "expires_in": 864000,
    "refresh_token": ""
}
```

### 1.3 Log out

_Revoke an access token._

##### Request

```
GET or POST {baseUrl}/oauth/logout
```

##### Response

```json
{
    "status": "OK"
}
```

## 2 Admin

### 2.1 Config

#### Config List

##### Request

```GET {baseUrl}/
GET {baseUrl}/admin/config
```

##### Response

```json
{
    "totalCount": 1,
    "pageSize": 10,
    "page": 1,
    "totalPage": 1,
    "list": [
        {
            "id": 1,
            "name": "side_menu",
            "value": null,
            "status": 1,
            "create_time": 1541873467,
            "update_time": null
        }
    ]
}
```

#### Add Config

##### Request (Unavailable)

```
POST {baseUrl}/admin/config/{config_name}
```

#### Get Config

##### Request

```
GET {baseUrl}/admin/config/{config_name}
```

#### Response

```json
{
    "id": 1,
    "name": "side_menu",
    "value": "123",
    "status": 1,
    "create_time": 1541873467,
    "update_time": null
}
```

#### Edit Config

##### Request

```
PUT {baseUrl}/admin/config/{config_name}
```

##### Request Body

```json
{"config_name": "value"} // @param mixed value - support int, string, array, object.
```

##### Response

```json
{
    "result": "OK",
    "updateCount": 1
}
```

#### 2.1.1 Side Menu

##### Side Menu Object Template

```json
{
    "incId": 4,
    "menuTree": [
        {
            "id": 1,
            "label": "ADMIN MANAGE",
            "type": "header",
            "children": [
                {
                    "id": 2,
                    "label": "User & Auth",
                    "type": "treeview",
                    "show": true,
                    "children": [
                        {
                            "id": 3,
                            "label": "User",
                            "type": "link",
                            "show": true,
                            "path": "fsdg5d1/fdg4vf"
                        }
                    ]
                }
            ]
        }
    ]
}
```

##### Get User Side Menu

_Authorize required_, user identified by access token.

###### Request

```GET {baseUrl}/
GET {baseUrl}/admin/sidemenu
```

###### Response

```json
[
    {
        "id": 1,
        "label": "ADMIN MANAGE",
        "type": "header",
        "children": [
            {
                "id": 2,
                "label": "User & Auth",
                "type": "treeview",
                "show": true,
                "children": [
                    {
                        "id": 3,
                        "label": "User",
                        "type": "link",
                        "show": true,
                        "path": "\/fsdg5d1\/fdg4vf",
                        "icon": "user"
                    }
                ],
                "icon": "user-circle"
            }
        ]
    }
]
```

### 2.2 Group

#### Get List

##### Request

```GET {baseUrl}/
GET {baseUrl}/admin/group
```

##### Response

```json
{
    "totalCount": 1,
    "pageSize": 10,
    "page": 1,
    "totalPage": 1,
    "list": [
        {
            "id": 1,
            "name": "Admin",
            "auth_menu": null,
            "auth_menu_json": null,
            "status": 1,
            "create_time": 1542165013,
            "update_time": null
        }
    ]
}
```

#### Add Item

##### Request

```
POST {baseUrl}/admin/group/
```

##### Request Body

```json
{
    "name": "string",
    "auth_menu": "stringify_json(optional)",
    "auth_menu_json": "stringify_json(optional)"
}
```

##### Response

```json
{
    "result": "OK",
    "id": "groupid(int)"
}
```

#### Set Item

##### Request

```
PUT {baseUrl}/admin/group/{groupid}
```

##### Request Body

```json
{
    "name": "string",
    "auth_menu": "stringify_json",
    "auth_menu_json": "stringify_json"
}
```

##### Response

```json
{
    "result": "OK",
    "id": "groupid(int)"
}
```

### 2.3 User

#### Get User Profile

_Authorize required_, user identified by access token.

##### Request

```GET {baseUrl}/
GET {baseUrl}/admin/profile
```

##### Response

```json
{
    "id": 1,
    "uid": null,
    "username": "admin",
    "nickname": null,
    "password": "admin",
    "group": "1",
    "last_login_ip": null,
    "last_login_time": null,
    "status": 1,
    "create_time": 1542164889,
    "update_time": null,
    "access_token": "6179f870c857f649559b732f90d045e4014fe2f0"
}
```

### Reference

1. [RFC 6749 - The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
2. [RFC 6750 - The OAuth 2.0 Authorization Framework: Bearer Token Usage](https://tools.ietf.org/html/rfc6750)