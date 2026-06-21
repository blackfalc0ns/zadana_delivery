# تعليمات البناء بعد تعديل Native Code

## التعديلات اللي اتعملت:

### 1. TripRequestSystemOverlay.kt
- تم تعديل `showAcceptConfirmationDialog()` و `showRejectConfirmationDialog()`
- دلوقتي لما السائق يدوس قبول/رفض، الـ native code:
  1. يعرض Toast "جاري قبول/رفض الطلب..."
  2. يبعت API request مباشرة
  3. يعرض Toast بالنتيجة (نجاح أو فشل)
  4. يفتح الأبلكيشن
  5. يبلغ Flutter بالنتيجة

### 2. NotificationApiService.kt
- تم تصحيح الـ API endpoints:
  - من: `/v1/driver/offers/{id}/accept` ❌
  - إلى: `/drivers/offers/{id}/accept` ✅

## خطوات البناء:

### للتجربة السريعة (Debug):
```bash
cd android
gradlew.bat assembleDebug
```

### أو من Flutter:
```bash
flutter build apk --debug
```

### للـ Release Build:
```bash
flutter build apk --release
```

## ملاحظات مهمة:

1. **لازم تعمل rebuild كامل** بعد تعديل الـ Kotlin files
2. الـ app هيحتاج يكون عنده:
   - Access token صحيح محفوظ في SharedPreferences
   - الـ base URL صحيح (default: https://api.zadna0.com/api)

3. للـ testing، تأكد إن:
   - الـ overlay permission متاح
   - الأبلكيشن مسجل دخول
   - في notification جديدة بتوصل

## Troubleshooting:

### لو قال "فشل قبول الطلب":
- شوف الـ logcat عشان تشوف الـ response code
- تأكد إن الـ token صحيح وما انتهاش
- تأكد إن الـ assignment ID صحيح

### لو الـ Toast ما ظهرش:
- تأكد إن الـ coroutine scope شغال صح
- شوف الـ logs بتاعة TripOverlay

### للوصول للـ Logcat:
```bash
adb logcat | findstr "NotificationApi TripOverlay NotificationAction"
```
