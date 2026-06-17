# تقرير مشكلة: إشعارات الطلب (Assignment) لا تصل للمندوب

**التاريخ:** 2026-06-13  
**التطبيق:** تطبيق المندوب (Driver App)  
**المشكلة:** إشعارات الطلب (assignment) لا تصل عندما يكون التطبيق مغلق (killed)، رغم أن التسجيل ناجح وكل الإعدادات مفعّلة.

---

## 1. ملخص المشكلة

إشعارات الطلب (فئة `assignment`) لا تصل للمندوب عندما يكون التطبيق مغلق.  
الموبايل مطبّق بالكامل حسب الـ handoff ولا يوجد أي نقص من جهة التطبيق.

---

## 2. ما تم التحقق منه (جانب الموبايل) ✅

| البند | الحالة | الدليل |
|---|---|---|
| `OneSignal.login(userId)` | ✅ صحيح | يتم بعد login مباشرة بـ `userId` من JWT |
| `oneSignalSubscriptionId` يُرسل | ✅ صحيح | UUID: `5e66776c-be95-44a0-ade2-f7f98c603156` |
| التسجيل ناجح (200 OK) | ✅ صحيح | `POST /api/drivers/notifications/devices/register` → 200 |
| `assignmentPushEnabled` | ✅ `true` | موجود في الـ response |
| `dispatchPushEnabled` | ✅ `true` | موجود في الـ response |
| `notificationsEnabled` | ✅ `true` | موجود في الـ response |
| `platform` | ✅ `Fcm` | صحيح لأندرويد |
| قناة Android | ✅ `zadana_heads_up_notifications` | Importance: HIGH |
| App ID | ✅ `1eead1ea-3d6f-4f2a-8bc5-c681d71b55f6` | App ID المندوب الصحيح |

---

## 3. بيانات التسجيل الفعلية (من الـ logs)

### Request (ما أرسله التطبيق):
```json
{
  "deviceId": "3e80b5ec-dcd1-4e4f-831d-4e52d410a561",
  "deviceToken": "<FCM token>",
  "platform": "Fcm",
  "deviceName": "Android",
  "appVersion": "1.0.0",
  "locale": "ar",
  "notificationsEnabled": true,
  "dispatchPushEnabled": true,
  "assignmentPushEnabled": true,
  "supportPushEnabled": true,
  "walletPushEnabled": true,
  "accountPushEnabled": true,
  "notificationSound": "classic",
  "oneSignalSubscriptionId": "5e66776c-be95-44a0-ade2-f7f98c603156",
  "pushSubscriptionId": "5e66776c-be95-44a0-ade2-f7f98c603156"
}
```

### Response (ما رجّعه الباك إند):
```json
{
  "id": "0171a839-1288-48f0-a825-9362ae2b5814",
  "deviceToken": "5e66776c-be95-44a0-ade2-f7f98c603156",
  "platform": "fcm",
  "deviceId": "3e80b5ec-dcd1-4e4f-831d-4e52d410a561",
  "deviceName": "Android",
  "appVersion": "1.0.0",
  "locale": "ar",
  "notificationsEnabled": true,
  "dispatchPushEnabled": true,
  "assignmentPushEnabled": true,
  "supportPushEnabled": true,
  "walletPushEnabled": true,
  "accountPushEnabled": true,
  "notificationSound": "classic",
  "isActive": true,
  "lastRegisteredAtUtc": "2026-06-13T14:32:37Z"
}
```

### معلومات المستخدم (من JWT):
- **userId (sub):** `1363aa39-64cb-42a8-9466-d2415f247c09`
- **Role:** `Driver`
- **OneSignal external_id:** نفس الـ userId أعلاه

---

## 4. الأسباب المحتملة (جانب الباك إند)

### السبب الأرجح: مسار DirectAsync لإشعارات الـ Assignment

حسب مستند الإصلاحات (يونيو 2026)، المفروض:
> إشعارات الطلب/المهمة (`assignment.*`): تحويلها إلى **DirectAsync** مثل عروض التوصيل.

**الاحتمالات:**

| # | السبب المحتمل | كيف تتحقق |
|---|---|---|
| 1 | كود DirectAsync لإشعارات assignment مش deployed أو مش active | راجع `AssignmentNotificationService` — هل يستخدم `DirectAsync` فعلاً؟ |
| 2 | الباك إند يرسل بـ `include_external_user_ids` بدل `include_subscription_ids` | راجع OneSignal API call في logs الباك إند |
| 3 | الباك إند يستخدم `driverId` كـ target بدل `userId` | تأكد إن الـ target هو `1363aa39-64cb-42a8-9466-d2415f247c09` |
| 4 | الـ instance القديم شغّال بدون الكود الجديد | أعد تشغيل بـ `dotnet watch --project src\Zadana.Api\Zadana.Api.csproj` (بدون `--no-build`) |
| 5 | `oneSignalSubscriptionId` مش محفوظ في DB بشكل منفصل | في الـ response، الـ `deviceToken` = UUID (subscription ID) — هل فيه حقل منفصل للـ subscription ID في الـ DB؟ |

---

## 5. ملاحظة مهمة على الـ Response

في الـ response، لاحظ إن:
```
"deviceToken": "5e66776c-be95-44a0-ade2-f7f98c603156"
```

هذا **UUID** (وهو الـ OneSignal Subscription ID) — مش FCM token حقيقي.  
FCM token يكون طويل جدًا (150+ حرف).

**سؤال للباك إند:** هل الـ `oneSignalSubscriptionId` اللي بيوصل في الـ request body بيتحفظ في حقل منفصل في الـ DB؟  
ولا بيكتب فوق الـ `deviceToken`؟

لأن الباك إند المفروض يستخدم `oneSignalSubscriptionId` أولًا في ترتيب الإرسال:
```
oneSignalSubscriptionId → subscriptionId → onesignal_id → deviceToken
```

لو الـ `oneSignalSubscriptionId` مش محفوظ كحقل منفصل والباك إند بيدور عليه فاضي، ممكن يفشل في إرسال الـ push.

---

## 6. خطوات التحقق المطلوبة من الباك إند

1. **شغّل الباك إند بنسخة جديدة:**
   ```powershell
   cd Zadana-Backend
   dotnet watch --project src\Zadana.Api\Zadana.Api.csproj
   ```
   > لا تستخدم `--no-build`

2. **أنشئ طلب وأسنده لهذا المندوب** (userId: `1363aa39-64cb-42a8-9466-d2415f247c09`)

3. **راقب logs الباك إند** وابحث عن:
   - هل يحاول إرسال push لفئة `assignment`؟
   - ما هو الـ subscription ID المستخدم في OneSignal API call؟
   - هل فيه error من OneSignal (مثل `invalid_player_ids`)؟

4. **تحقق من DB:**
   ```sql
   SELECT Id, DeviceToken, OneSignalSubscriptionId, DeviceId, AssignmentPushEnabled
   FROM NotificationDevices
   WHERE DeviceId = '3e80b5ec-dcd1-4e4f-831d-4e52d410a561'
   ```
   - هل `OneSignalSubscriptionId` محفوظ كحقل منفصل؟
   - ولا `DeviceToken` هو اللي فيه الـ UUID؟

---

## 7. سؤال تأكيدي

**هل إشعارات عروض التوصيل (dispatch/delivery offer) بتوصل والتطبيق مقفول؟**

- **لو أيوا:** المشكلة محصورة في مسار `assignment` فقط → الباك إند محتاج يفعّل DirectAsync لهذا المسار.
- **لو لأ:** المشكلة أعمق — ممكن OneSignal subscription مش matching.

---

## 8. دليل إضافي: SignalR شغّال لكن بدون assignment events

من logs التطبيق أثناء الاستخدام الفعلي، الـ SignalR **شغّال** وبيوصل events:

```
✅ signalr_driver_home_updated → "Driver home updated"
✅ signalr_notification → "الحساب محظور مؤقتًا" (category: account, event: performance.soft_blocked)
```

**لكن مفيش أي event من نوع assignment وصل** — لا عبر SignalR ولا عبر push.

هذا يؤكد:
- SignalR connection سليم ✅
- OneSignal subscription سليم ✅
- **الباك إند ببساطة مش بيرسل assignment notification لما الطلب يتسند أو يتحدث** ❌

المطلوب: تأكدوا إن الكود اللي بيعمل trigger لـ `assignment.*` events فعلاً شغّال ومتصل بالـ order/task lifecycle.

---

## 9. مشكلة إضافية: بيانات عرض التوصيل ناقصة في الـ Push Payload

عند وصول عرض التوصيل (delivery offer) والتطبيق killed، الـ **native system overlay** بيظهر لكن **ناقص بيانات** مهمة:

### ما يظهر ✅
- العنوان "طلب توصيل جديد"
- العد التنازلي (54s)
- عدد الأصناف (30 صنف)
- أزرار قبول/رفض

### ما لا يظهر ❌
- أجرة التوصيل (payout)
- اسم المتجر (vendorName)
- عنوان الاستلام (pickupAddress)
- اسم العميل (customerName)
- عنوان التسليم (deliveryAddress)
- المسافة (estimatedDistanceKm)
- الوقت المتوقع (estimatedEta)
- إجمالي الطلب (totalAmount)
- طريقة الدفع (paymentMethod)

### السبب
الـ push payload بتاع `dispatch.offer_new` **لا يحتوي على كل الحقول** المطلوبة للعرض الكامل.

الـ native overlay يبني الشاشة من الـ push data مباشرة. لو الحقل فاضي أو `= 0`، العنصر لا يظهر.

### المطلوب من الباك إند
أضيفوا الحقول التالية في `data` بتاع push notification لعروض التوصيل:

```json
{
  "assignmentId": "uuid",
  "orderId": "uuid",
  "orderNumber": "#12345",
  "vendorName": "اسم المتجر",
  "pickupAddress": "عنوان الاستلام",
  "deliveryAddress": "عنوان التسليم",
  "customerName": "اسم العميل",
  "estimatedDistanceKm": 3.5,
  "estimatedEta": "12 دقيقة",
  "payout": 15.0,
  "totalAmount": 85.0,
  "codAmount": 85.0,
  "paymentMethod": "cash",
  "countdownSeconds": 60,
  "itemsCount": 30
}
```

> **ملاحظة**: لما العرض يوصل عبر SignalR (التطبيق في الخلفية لكن مش killed)، البيانات كاملة لأن `ReceiveDeliveryOffer` event فيه كل الحقول. المشكلة بس في push payload لما التطبيق killed.

---

## 10. الخلاصة

**من جهة الموبايل: كل شيء مطبّق صح.**  
المطلوب من الباك إند:
1. التأكد إن `oneSignalSubscriptionId` محفوظ في DB كحقل منفصل.
2. التأكد إن مسار إشعارات الـ assignment يستخدم **DirectAsync** + **subscription-first**.
3. التأكد إن الـ target هو `userId` وليس `driverId`.
4. إعادة تشغيل الباك إند بآخر build.
