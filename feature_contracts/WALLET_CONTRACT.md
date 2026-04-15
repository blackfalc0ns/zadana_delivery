# wallet

## status
- `mock`

## Current Wallet Snapshot Response
```json
{
  "currentBalance": 0,
  "availableToWithdraw": 0,
  "pendingBalance": 0,
  "todayEarnings": 0,
  "weekEarnings": 0,
  "monthEarnings": 0,
  "transactions": [
    {
      "kind": "delivery|withdrawal|bonus|adjustment",
      "status": "completed|pending|failed",
      "amount": 0,
      "date": "ISO8601",
      "reference": "string",
      "note": "string"
    }
  ],
  "paymentMethods": [
    {
      "kind": "bankAccount|debitCard|instantTransfer",
      "maskedLabel": "string",
      "isPrimary": true,
      "isVerified": true
    }
  ],
  "bonuses": [
    {
      "kind": "weekend|consistency|peakHours",
      "progress": 0,
      "deadline": "ISO8601",
      "rewardLabel": "string"
    }
  ],
  "alerts": [
    {
      "titleKey": "string",
      "subtitleKey": "string",
      "action": "verify|view|claim"
    }
  ]
}
```

## Suggested Future Endpoints
- `GET /drivers/wallet`
- `GET /drivers/wallet/transactions`
- `GET /drivers/wallet/payment-methods`
- `POST /drivers/wallet/withdrawals`

## Notes
- wallet uses local fake data from `wallet_fake_data.dart`.
- success, empty, and error states are currently presentation states, not backend states.
