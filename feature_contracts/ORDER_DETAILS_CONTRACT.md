# order details

## status
- `mock`

## Current Order Details Shape
```json
{
  "id": "string",
  "vendorName": "string",
  "pickupAddress": "string",
  "pickupLatitude": 0,
  "pickupLongitude": 0,
  "customerName": "string",
  "deliveryAddress": "string",
  "deliveryLatitude": 0,
  "deliveryLongitude": 0,
  "paymentMethod": "cash|visa",
  "pickupOtp": "string",
  "storePhone": "string",
  "customerPhone": "string",
  "orderItems": [
    {
      "name": "string",
      "quantity": 1,
      "note": "string"
    }
  ],
  "stage": "pending|accepted|pickedUp|onTheWay|delivered"
}
```

## Suggested Future Endpoints
- `GET /drivers/orders/{order_id}`
- `POST /drivers/orders/{order_id}/accept`
- `POST /drivers/orders/{order_id}/pickup-confirmation`
- `POST /drivers/orders/{order_id}/delivery-confirmation`

## Notes
- current order stage transitions are fully local inside `OrderDetailsController`.
- `paymentMethod`, `pickupOtp`, and phone values are generated locally for now.
