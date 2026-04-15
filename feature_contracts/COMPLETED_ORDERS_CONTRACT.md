# completed orders

## status
- `mock`

## Current Completed Orders Response
```json
{
  "items": [
    {
      "id": "string",
      "merchantName": "string",
      "customerName": "string",
      "completedAt": "ISO8601",
      "status": "delivered|cancelled|deliveryFailed",
      "amount": 0,
      "distanceKm": 0,
      "paymentMethod": "cashOnDelivery|card|applePay|bankTransfer",
      "deliveryAddress": "string",
      "items": [
        {
          "name": "string",
          "quantity": 1,
          "note": "string"
        }
      ]
    }
  ]
}
```

## Current Filter Input
- `status`: `delivered|cancelled|deliveryFailed`

## Suggested Future Endpoints
- `GET /drivers/orders/completed`
- `GET /drivers/orders/completed/{order_id}`

## Notes
- current screen data is seeded locally inside `completed_orders_screen.dart`.
- sorting and filtering are performed on-device.
