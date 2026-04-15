# notifications

## status
- `ui only`

## Current Notification Item Shape
```json
{
  "title": "string",
  "body": "string",
  "time": "string",
  "isUnread": true
}
```

## Suggested Future Endpoints
- `GET /drivers/notifications`
- `POST /drivers/notifications/read-all`
- `POST /drivers/notifications/{notification_id}/read`

## Notes
- notifications screen is prepared UI with static items only.
