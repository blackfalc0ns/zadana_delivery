# driver home

## status
- `mock`

## Current Incoming Order Shape
```json
{
  "id": "string",
  "title": "string",
  "vendorName": "string",
  "pickupAddress": "string",
  "pickupLatitude": 0,
  "pickupLongitude": 0,
  "customerName": "string",
  "deliveryAddress": "string",
  "deliveryLatitude": 0,
  "deliveryLongitude": 0,
  "distance": "string",
  "eta": "string",
  "payout": "string",
  "vendorInitials": "string",
  "customerInitials": "string",
  "packageNote": "string",
  "countdownSeconds": 60,
  "orderItems": [
    {
      "name": "string",
      "quantity": 1,
      "note": "string"
    }
  ]
}
```

## Suggested Future Endpoints
- `GET /drivers/orders/incoming`
- `POST /drivers/orders/{order_id}/accept`
- `POST /drivers/orders/{order_id}/reject`
- `PATCH /drivers/availability`

## Notes
- current home map and incoming orders are seeded in `driver_home_screen_data.dart`.
- no home/orders API is wired in the current codebase yet.
