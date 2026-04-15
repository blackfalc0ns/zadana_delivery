# driver profile completion

## status
- `local`

## Current Local Draft Shape
```json
{
  "vehicleType": "bike|car",
  "address": "string",
  "nationalId": "string",
  "licenseNumber": "string",
  "vehicleBrand": "string",
  "vehicleModel": "string",
  "plateNumber": "string",
  "images": {
    "portrait": "string",
    "idFront": "string",
    "license": "string",
    "vehicle": "string",
    "plate": "string"
  }
}
```

## Required Upload Keys
- `portrait`
- `idFront`
- `license`
- `vehicle`
- `plate`

## Notes
- no dedicated API submission is wired yet in the current codebase.
- data is stored locally through `DriverProfileService` and marks the profile as complete when all required fields and images are present.
- completion currently navigates to pending approval UI after local save.
