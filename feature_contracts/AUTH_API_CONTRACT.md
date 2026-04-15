# auth

## status
- `live api`

## Base URL
- `https://zadana.runasp.net/api`

## Endpoints
- `POST /drivers/register`
- `POST /drivers/auth/login`
- `POST /drivers/auth/forgot-password`
- `POST /drivers/auth/reset-password`
- `POST /drivers/auth/logout`
- `GET /drivers/auth/me`

## Register Request
```json
{
  "fullName": "string",
  "email": "string",
  "phone": "string",
  "password": "string",
  "vehicleType": null,
  "nationalId": null,
  "licenseNumber": null,
  "address": null,
  "nationalIdImageUrl": null,
  "licenseImageUrl": null,
  "vehicleImageUrl": null,
  "personalPhotoUrl": null
}
```

## Register Response
```json
{
  "message": "string",
  "isVerified": true,
  "user": {
    "id": "string",
    "fullName": "string",
    "email": "string",
    "phone": "string",
    "role": "driver"
  }
}
```

## Login Request
```json
{
  "identifier": "string",
  "password": "string"
}
```

## Login Response
```json
{
  "message": "string",
  "accessToken": "string",
  "refreshToken": "string",
  "user": {
    "id": "string",
    "fullName": "string",
    "email": "string",
    "phone": "string",
    "role": "driver"
  }
}
```

## Forgot Password Request
```json
{
  "identifier": "string"
}
```

## Forgot Password Response
```json
{
  "message": "string"
}
```

## Reset Password Request
```json
{
  "identifier": "string",
  "otpCode": "string",
  "newPassword": "string"
}
```

## Reset Password Response
```json
{
  "message": "string"
}
```

## Logout Request
```json
{
  "refreshToken": "string"
}
```

## Driver Profile Response
```json
{
  "id": "string",
  "fullName": "string",
  "email": "string",
  "phone": "string",
  "role": "driver"
}
```

## Notes
- login accepts email or phone in `identifier`.
- the app also supports nested token responses like:
```json
{
  "tokens": {
    "accessToken": "string",
    "refreshToken": "string"
  }
}
```
- after login/register the app stores identity locally for profile screens.
