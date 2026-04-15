# profile

## status
- `local`

## Current Local Identity Shape
```json
{
  "id": "string",
  "fullName": "string",
  "email": "string",
  "phone": "string",
  "role": "driver",
  "lastIdentifier": "string"
}
```

## Personal Info Save Payload
```json
{
  "fullName": "string",
  "email": "string",
  "phone": "string",
  "address": "string"
}
```

## Vehicle Info Save Payload
```json
{
  "vehicleType": "bike|car",
  "vehicleBrand": "string",
  "vehicleModel": "string",
  "plateNumber": "string"
}
```

## Security Documents Save Payload
```json
{
  "nationalId": "string",
  "licenseNumber": "string",
  "images": {
    "portrait": "string",
    "idFront": "string",
    "license": "string",
    "vehicle": "string",
    "plate": "string"
  }
}
```

## Notes
- profile screens currently read/write from local shared preferences only.
- logout from profile clears the local session directly.
- no profile update endpoint is wired yet.
