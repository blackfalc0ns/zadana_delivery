# Feature Structure Template

الملف ده معمول كمرجع ثابت تقدر تمشي عليه في أي feature جديدة.
الفكرة إن كل feature تتقسم لنفس 3 layers:

- `presentation`
- `domain`
- `data`

## Base Structure

```text
lib/feature/<module>/<feature_name>/
├── presentation/
│   ├── pages/
│   │   └── <feature_name>_screen.dart
│   ├── manager/
│   │   ├── <feature_name>_event.dart
│   │   ├── <feature_name>_state.dart
│   │   └── <feature_name>_view_model.dart
│   └── widget/
│       └── ...
├── domain/
│   ├── entities/
│   │   ├── <feature_name>_request_entity.dart
│   │   └── <feature_name>_response_entity.dart
│   ├── repo/
│   │   └── <feature_name>_repository.dart
│   └── usecase/
│       └── <feature_name>_usecase.dart
└── data/
    ├── data_source/
    │   ├── <feature_name>_remote_data_source.dart
    │   └── <feature_name>_remote_data_source_impl.dart
    ├── models/
    │   ├── <feature_name>_request_model_dto.dart
    │   ├── <feature_name>_request_model_dto.g.dart
    │   ├── <feature_name>_response_model_dto.dart
    │   └── <feature_name>_response_model_dto.g.dart
    ├── mapper/
    │   └── mapper_<feature_name>.dart
    └── repo/
        └── <feature_name>_repository_impl.dart
```

## Layer Responsibility

### `presentation`

دي طبقة الـ UI والتعامل مع المستخدم.

- `pages`
  الشاشة الأساسية للفيتشر.

- `manager`
  مسؤول عن state management.
  غالباً بيحتوي:
  - `event`
  - `state`
  - `view_model` أو `cubit` أو `bloc`

- `widget`
  Widgets صغيرة خاصة بالفيتشر.

### `domain`

دي طبقة الـ business logic والعقود المجردة.

- `entities`
  موديلات pure dart من غير أي dependency على API أو UI.

- `repo`
  abstract contract بين الـ domain والـ data.

- `usecase`
  كل action رئيسي في الفيتشر بيتحط هنا.

### `data`

دي طبقة التنفيذ الفعلي والتعامل مع الـ API أو local storage.

- `data_source`
  المصدر المباشر للداتا.

- `models`
  DTOs الخاصة بالـ request والـ response.

- `mapper`
  التحويل بين `Entity` و `DTO`.

- `repo`
  implementation للـ repository contract.

## Standard Flow

أي feature تمشي غالباً بالشكل ده:

1. الـ UI يبعث action.
2. الـ `ViewModel` أو `Cubit` يستقبل الـ event.
3. ينادي `UseCase`.
4. الـ `UseCase` ينادي `Repository`.
5. الـ `RepositoryImpl` يكلم `DataSource`.
6. الـ `DataSource` يكلم API أو local storage.
7. الـ response يرجع كـ DTO.
8. يحصل mapping إلى Entity.
9. الـ state تتحدث.
10. الـ UI تعيد البناء حسب الحالة.

## Naming Convention

امشِ على naming ثابت في أي feature:

- `<feature_name>_screen.dart`
- `<feature_name>_event.dart`
- `<feature_name>_state.dart`
- `<feature_name>_view_model.dart`
- `<feature_name>_usecase.dart`
- `<feature_name>_repository.dart`
- `<feature_name>_repository_impl.dart`
- `<feature_name>_remote_data_source.dart`
- `<feature_name>_remote_data_source_impl.dart`
- `<feature_name>_request_entity.dart`
- `<feature_name>_response_entity.dart`
- `<feature_name>_request_model_dto.dart`
- `<feature_name>_response_model_dto.dart`
- `mapper_<feature_name>.dart`

## Build Order

لما تبدأ feature جديدة امشِ بالترتيب ده:

1. اعمل `domain`
2. اعمل `data`
3. اعمل `presentation`
4. اربط dependency injection
5. شغل code generation لو فيه `.g.dart`

## Rules To Keep

- الـ UI ما تعرفش تفاصيل الـ API
- الـ domain ما يعتمدش على DTOs
- الـ data هي اللي تعرف شكل الـ API الحقيقي
- الـ mapping يكون واضح ومفصول
- أي side effects تتحط في مكان واضح داخل `data`

## Quick Copy Template

لو هتعمل feature جديدة باسم `profile`, مثلاً:

```text
lib/feature/profile/
├── presentation/
├── domain/
└── data/
```

وبعدها تطبق نفس التقسيمة الداخلية ونفس naming pattern.

