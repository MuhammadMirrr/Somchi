fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios register_bundle_id

```sh
[bundle exec] fastlane ios register_bundle_id
```

Bundle ID (App ID)ni Apple Developer portalida ro'yxatga olish

### ios create_app

```sh
[bundle exec] fastlane ios create_app
```

App Store Connect da Valyutachi app yozuvini yaratish (API key orqali, produce'siz)

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Valyutachi IPA ni App Store Connect ga yuklash

### ios list_apps

```sh
[bundle exec] fastlane ios list_apps
```

Diagnostika: shu hisobdagi barcha app yozuvlarini ko'rsatish

### ios check_build

```sh
[bundle exec] fastlane ios check_build
```

Diagnostika: versiyaga biriktirilgan build holatini ko'rsatish

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Faqat matn metadata'ni yuklash

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Faqat screenshotlarni yuklash

### ios fix_review_requirements

```sh
[bundle exec] fastlane ios fix_review_requirements
```

Review uchun qolgan majburiy deklaratsiyalarni to'ldirish: yosh reytingi, kontent huquqi

### ios set_free_pricing

```sh
[bundle exec] fastlane ios set_free_pricing
```

Narxni Free (0.00 USD, barcha hududlarda) qilib belgilash

### ios submit

```sh
[bundle exec] fastlane ios submit
```

Tayyor versiyani Apple review'ga yuborish

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
