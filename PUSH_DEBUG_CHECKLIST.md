# Push Notification Debug Checklist — للباك إند

## المشكلة

المندوب مش بيستلم إشعار الأوردر الجديد لما التطبيق مقفول (killed).  
تيست من OneSignal Dashboard شغال — يعني الجهاز مسجل والـ FCM token سليم.

---

## البيانات اللي هتظهر في Logcat بعد Login

بعد ما المندوب يعمل login، التطبيق بيطبع:

```
[PUSH DEBUG] Final state after authentication
  userId sent to OneSignal.login(): <USER_ID>
  OneSignal externalId: <USER_ID>
  OneSignal subscriptionId: <SUBSCRIPTION_ID>
  FCM pushToken: <TOKEN>
  deviceId: <DEVICE_ID>
```

---

## اللي الباك إند لازم يتأكد منه

### 1. الـ External User ID

OneSignal بيتربط بـ `userId` (مش `driverId`).

```
external_user_id = userId من response بتاع login
```

الباك إند لما يبعت إشعار لازم يستخدم **نفس الـ `userId`** اللي التطبيق بعته لـ OneSignal.

---

### 2. طريقة إرسال الإشعار عبر OneSignal API

#### OneSignal REST API v2 (الموصى بها):

```json
POST https://api.onesignal.com/notifications
{
  "app_id": "1eead1ea-3d6f-4f2a-8bc5-c681d71b55f6",
  "target_channel": "push",
  "include_aliases": {
    "external_id": ["<USER_ID_HERE>"]
  },
  "contents": { "en": "New delivery offer", "ar": "عرض توصيل جديد" },
  "headings": { "en": "New Order", "ar": "طلب جديد" },
  "existing_android_channel_id": "zadana_heads_up_notifications",
  "priority": 10,
  "data": {
    "presentation": "popup",
    "showPopup": true,
    "popupType": "delivery_offer",
    "eventName": "dispatch.offer_new",
    "targetUrl": "/",
    "category": "dispatch"
  }
}
```

#### OneSignal REST API v1 (Legacy):

```json
POST https://onesignal.com/api/v1/notifications
{
  "app_id": "1eead1ea-3d6f-4f2a-8bc5-c681d71b55f6",
  "include_external_user_ids": ["<USER_ID_HERE>"],
  "contents": { "en": "New delivery offer", "ar": "عرض توصيل جديد" },
  "headings": { "en": "New Order", "ar": "طلب جديد" },
  "existing_android_channel_id": "zadana_heads_up_notifications",
  "priority": 10,
  "data": {
    "presentation": "popup",
    "showPopup": true,
    "popupType": "delivery_offer",
    "eventName": "dispatch.offer_new",
    "targetUrl": "/",
    "category": "dispatch"
  }
}
```

---

### 3. أخطاء شائعة

| خطأ | التأثير |
|-----|---------|
| استخدام `driverId` بدل `userId` كـ external_user_id | الإشعار يروح لـ user مش موجود |
| استخدام `include_player_ids` بـ subscription ID قديم | الإشعار يروح لجهاز مش مسجل |
| عدم إرسال `existing_android_channel_id` | الإشعار ممكن يوصل silent بدون heads-up |
| إرسال `android_channel_id` داخل `data` بدل top-level | Android مش بيقرأه من `data` |

---

### 4. التحقق من OneSignal Dashboard

1. **Audience** → ابحث عن الـ user بالـ External User ID
2. تأكد إن الـ **Subscription** active ومعاه FCM token
3. **Delivery** → شوف آخر إشعار:
   - `Delivered` = وصل الجهاز (مشكلة في الـ channel أو DND)
   - `Not Sent` / `Errored` = مشكلة في الاستهداف

---

### 5. Device Registration Endpoint

التطبيق بيسجل الجهاز على:

```
POST /api/drivers/notifications/devices/register
```

بـ body فيها:

```json
{
  "deviceId": "<stable-uuid>",
  "deviceToken": "<fcm-token>",
  "platform": "Fcm",
  "oneSignalSubscriptionId": "<onesignal-subscription-id>",
  "notificationsEnabled": true,
  "dispatchPushEnabled": true
}
```

لو الباك إند بيستخدم الـ `oneSignalSubscriptionId` لإرسال الإشعار بدل `external_user_id` — **دا خطأ**. الطريقة الصح هي `include_aliases.external_id` بالـ `userId`.

---

## ملخص

| ماذا | القيمة الصحيحة |
|------|----------------|
| OneSignal external_user_id | `userId` من login response |
| Android channel | `zadana_heads_up_notifications` |
| Priority | `10` |
| Targeting method | `include_aliases.external_id` (v2) أو `include_external_user_ids` (v1) |
| App ID | `1eead1ea-3d6f-4f2a-8bc5-c681d71b55f6` |
