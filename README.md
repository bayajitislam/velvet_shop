# velvet.

> *Discover Your Signature Look*

**velvet.** is a modern fashion & lifestyle e-commerce app built with Flutter. It offers a polished shopping experience — product discovery, search & filtering, wishlist, cart, checkout, and a full user account flow — wrapped in a clean, blush-pink themed UI.

---

## ✨ Features

- **Splash & Onboarding** — animated splash screen with token-based auth check
- **Authentication** — sign up / sign in with form validation and social login UI (Google, Facebook)
- **Home** — banner carousel, category chips, search bar, and a popular-products grid
- **Product Discovery** — search, category browsing, and a filter sheet (category, price range, sort)
- **Product Details** — image gallery with zoom, size selector & size guide, quantity counter, and add-to-cart CTA
- **Wishlist** — save favorite products
- **Cart & Checkout** — manage cart items, checkout flow, and an order-success confirmation
- **Profile** — edit profile, my orders, saved addresses, payment methods, notifications, and help/privacy pages
- **Guest browsing** — products are free to browse; protected actions (cart, wishlist, checkout, profile) prompt sign-in via an auth middleware

---

## 🏗️ Architecture

The project follows a **feature-first** structure with the **GetX** pattern (controllers, bindings, repositories, models, views).

```
lib/
├── main.dart                  # Entry point — initializes GetStorage
├── app.dart                   # Root GetMaterialApp + routing
├── core/
│   ├── common/                # Shared widgets (loader, dialog, icon buttons)
│   ├── constants/             # App strings & image paths
│   ├── errors/                # Failure handling
│   ├── middleware/            # Auth route guard
│   ├── services/              # e.g. URL launcher
│   ├── theme/                 # Color palette, text styles, app theme
│   ├── utils/                 # Helpers (screen size, app bar menu, debug)
│   └── widgets/               # Primary button, custom bottom nav bar
├── routes/
│   ├── routes_name.dart       # Named route constants
│   └── app_routes.dart        # GetPage route definitions + bindings
└── features/
    ├── splash/
    ├── auth/
    ├── home/                  # Home + product details & widgets
    ├── wishlist/
    ├── cart/                  # Cart, checkout, order success
    └── profile/
```

Each feature is organized into `view/`, `controllers/`, `bindings/`, `repositories/`, `models/`, and `widgets/`.

> **Note:** Data is currently served from in-repo mock repositories (with simulated network delays). Replace the repository implementations with real API calls to connect a backend.

---

## 🛠️ Tech Stack

| Concern            | Package                          |
| ------------------ | -------------------------------- |
| Framework          | Flutter (Dart SDK `^3.10.8`)     |
| State management   | [`get`](https://pub.dev/packages/get) (GetX) |
| Local storage      | [`get_storage`](https://pub.dev/packages/get_storage) |
| Fonts              | [`google_fonts`](https://pub.dev/packages/google_fonts) |
| URL launching      | [`url_launcher`](https://pub.dev/packages/url_launcher) |
| Icons              | [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) |
| Linting            | [`flutter_lints`](https://pub.dev/packages/flutter_lints) |

---

## 🎨 Theme

A blush-pink brand palette defined in `lib/core/theme/app_pallete.dart`:

- **Primary:** `#E91E63` (pink accent / CTA)
- **Primary Dark:** `#AD1457` (deep rose)
- **Background:** `#FCE4EC` (light pink)
- **Scaffold:** `#FFF8FA` (near-white with pink tint)

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.10.8`)
- A configured device/emulator (Android, iOS) or desktop/web target

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/bayajitislam/velvet_shop
cd velvet

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build

```bash
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

---

## 📱 Supported Platforms

Android · iOS · Web · macOS · Linux · Windows

---

## 📂 Routes

Named routes are centralized in `lib/routes/routes_name.dart` and wired in `lib/routes/app_routes.dart`. Protected routes (cart, wishlist, checkout, profile) are guarded by `AuthMiddleware`, which prompts guests to sign in before continuing.

---

## 📄 License

This project is private and not published to pub.dev (`publish_to: 'none'`).
