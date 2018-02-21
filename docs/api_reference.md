# API

## Requests

### **POST** - /oauth/token

#### CURL

```sh
curl -X POST "https://fabric.io/oauth/token" \
    -H "Content-Type: application/json" \
    --data-raw "$body"
```

#### Header Parameters

- **Content-Type** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "application/json"
  ],
  "default": "application/json"
}
```

#### Body Parameters

- **body** should respect the following schema:

```
{
  "type": "string",
  "default": "{\"grant_type\":\"password\",\"scope\":\"organizations apps issues features account twitter_client_apps beta software answers\",\"username\":\"email@email.ru\",\"password\":\"pa$$word\",\"client_id\":\"your_client_id\",\"client_secret\":\"your_client_secret\"}"
}
```

### **GET** - /api/v2/organizations

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations" \
    -H "Authorization: Bearer {access_token}"
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/apps

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/apps" \
    -H "Authorization: Bearer {access_token}"
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/apps/{app_id}

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/apps/{app_id}" \
    -H "Authorization: Bearer {access_token}"
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/active_now.json

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/active_now.json\
?build=all" \
    -H "Authorization: Bearer {access_token}"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **build** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "all",
    "x.x.x (y)"
  ],
  "default": "all"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/daily_new.json

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/daily_new.json\
?start=1478736000&end=1481328000&build=all" \
    -H "Authorization: Bearer {access_token}"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **start** should respect the following schema:

```
{
  "type": "timestamp",
}
```
- **end** should respect the following schema:

```
{
  "type": "timestamp",
}
```
- **build** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "all",
    "x.x.x (y)"
  ],
  "default": "all"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/daily_active.json

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/daily_active.json\
?start=1478736000&end=1481328000&build=3.0.4%20(71)" \
    -H "Authorization: Bearer {access_token}"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **start** should respect the following schema:

```
{
  "type": "timestamp",
}
```
- **end** should respect the following schema:

```
{
  "type": "timestamp",
}
```
- **build** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "all",
    "x.x.x (y)"
  ],
  "default": "all"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **POST** - /graphql

#### CURL

```sh
curl -X POST "https://api-dash.fabric.io/graphql" \
    -H "Authorization: Bearer {access_token}" \
    -H "Content-Type: application/json" \
    --data-raw "$body"
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```
- **Content-Type** should respect the following schema:

```
{
  "type": "string",
  "default": "application/json"
}
```

#### Body Parameters

- **body** should respect the following schema:

```
{
  "type": "string",
  "default": "{\n  \"query\": \"query AppScalars($app_id:String!,$type:IssueType!) {project(externalId:$app_id) {crashlytics {scalars:scalars(synthesizedBuildVersions:[\\\"x.x.x (y)\\\", \\\"x.x.x (y)\\\"],type:$type,start:1477958400,end:1480411080) {crashes,issues,impactedDevices}}}}\",\n  \"variables\": {\n    \"app_id\": \"{app_id}\",\n    \"type\": \"crash\"\n  }\n}"
}
```
- **synthesizedBuildVersions** should respect the following schema:

```
{
  "type": "string",
  "default": "[\"x.x.x (y)\"]"
}
```

- **start** should respect the following schema:

```
{
  "type": "timestamp"
}
```

- **end** should respect the following schema:

```
{
  "type": "timestamp"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/total_sessions_scalar.json

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/total_sessions_scalar.json\
?build=all&start=1480636800&end=1480723200" \
    -H "Authorization: Bearer {access_token}" \
    -H "Content-Type: text/plain"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **build** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "all",
    "x.x.x (y)"
  ],
  "default": "all"
}
```
- **start** should respect the following schema:

```
{
  "type": "timestamp"
}
```
- **end** should respect the following schema:

```
{
  "type": "timestamp"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **POST** - /graphql

#### CURL

```sh
curl -X POST "https://api-dash.fabric.io/graphql" \
    -H "Authorization: Bearer {access_token}" \
    -H "Content-Type: application/json" \
    --data-raw "$body"
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```
- **Content-Type** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "application/json"
  ],
  "default": "application/json"
}
```

#### Body Parameters

- **body** should respect the following schema:

```
{
  "type": "string",
  "default": "{\n  \"query\": \"query oomCountForDaysForBuild($app_id: String!, $builds: [String!]!, $days: Int!) { project(externalId: $app_id) { crashlytics{ oomCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } oomSessionCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } } } }\",\n  \"variables\": {\n    \"app_id\": \"{app_id}\",\n    \"days\": 1,\n    \"builds\": [\n      \"3.0.4 (71)\"\n    ]\n  }\n}"
}
```

- **builds** should respect the following schema:

```
{
  "type": "string",
  "default": "[\"x.x.x (y)\"]"
}
```

- **app_id** should respect the following schema:

```
{
  "type": "string"
}
```

- **days** should respect the following schema:

```
{
  "type": "integer"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/beta_distribution/releases/{release_id}

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/beta_distribution/releases/{release_id}" \
    -H "Authorization: Bearer {access_token}" \
    -H "Content-Type: text/plain"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/beta_distribution/releases

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/beta_distribution/releases\
?app%5Bdisplay_version%5D=3.0.5&app%5Bbuild_version%5D=75" \
    -H "Authorization: Bearer {access_token}"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **app[display_version]** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "x.x.x"
  ]
}
```
- **app[build_version]** should respect the following schema:

```
{
  "type": "string",
  "enum": [
    "y"
  ]
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

### **GET** - /api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/top_builds

#### CURL

```sh
curl -X GET "https://fabric.io/api/v2/organizations/{organization_id}/apps/{app_id}/growth_analytics/top_builds\
?start=0&app_id={app_id}&end=1481328000" \
    -H "Authorization: Bearer {access_token}"
```

#### Path Parameters

- **ResponseBodyPath** should respect the following schema:

```
{
  "type": "string",
  "default": "{organization_id}"
}
```

#### Query Parameters

- **app_id** should respect the following schema:

```
{
  "type": "string",
  "default": "{app_id}"
}
```
- **start** should respect the following schema:

```
{
  "type": "timestamp"
}
```
- **end** should respect the following schema:

```
{
  "type": "timestamp"
}
```

#### Header Parameters

- **Authorization** should respect the following schema:

```
{
  "type": "string",
  "default": "Bearer {access_token}"
}
```

## References

- [API in Swagger format](swagger-api.json)
