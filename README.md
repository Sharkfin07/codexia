# Codexia
<img width="1920" height="1080" alt="codexia-hero" src="https://github.com/user-attachments/assets/9bd62cf2-d9dd-4f78-acb5-f2e37641dfca" />
Release: 1.0.0

## Overview
Codexia is a Flutter app to discover, rent, and save (wishlist) books. It uses Riverpod for state, Firebase Auth for identity, and Firestore for data.

## Features
- Auth: sign-in, sign-up, reset password, edit profile (Firebase Auth-backed).
- Home: time-based greeting (uses display name/email); gradient quick actions to Explore Filter, Rentals, Wishlist.
- Explore & Filter: browse and filter catalog.
- Book Detail: metadata, summary, price, Buy (web search), Rent; wishlist toggle in AppBar heart.
- Rentals: view/manage current rentals.
- Wishlist: list, delete, tap-through to detail; pull-to-refresh.
- Theming: light/dark via AppTheme; brand colors in AppPalette; bottom navigation with google_nav_bar.

## Architecture (at a glance)
```
lib/
├─ main.dart (boot, routes, ProviderScope)
├─ presentation/
│  ├─ screens/ (auth, main, books, explore, order, wishlist)
│  ├─ providers/ (auth, book_detail, wishlist, rental)
│  ├─ widgets/ (global UI, nav bar, book items)
│  └─ theme/ (app_palette, app_theme)
├─ data/
│  ├─ models/ (book, rental, user, wishlist_item)
│  ├─ repositories/ (book, rental, wishlist)
│  └─ services/ (auth_service, book_service, firestore_service, api_client)
└─ firebase_options.dart
```

## Tech Stack
- Flutter, Dart 3.10+
- Riverpod 3 (flutter_riverpod, riverpod_annotation + generator)
- Firebase: firebase_core, firebase_auth, cloud_firestore
- Network/util: dio, url_launcher
- UI: google_nav_bar, flutter_svg, Poppins font

## Setup
1) Ensure Flutter SDK is installed and mobile targets are configured.
2) Firebase config present: `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, and `lib/firebase_options.dart` (already checked in).
3) Install deps: `flutter pub get`
4) Run: `flutter run`

## Navigation Map
- Auth guarded home: shows Home when signed in, Sign In screen otherwise.
- Routes: `/sign-in`, `/sign-up`, `/forgot-password`, `/profile`, `/profile/edit`, `/profile/reset-password`, `/explore`, `/explore/filter`, `/books/detail`, `/books/rent`, `/wishlist`, `/rental`, `/home`.
- Bottom tabs: Home, Explore, Rentals, Profile.

## Known Limitations
- Remote cover images may fail; placeholders are shown on error.

## Key Files
- App entry: [lib/main.dart](lib/main.dart)
- Home: [lib/presentation/screens/main/home_screen.dart](lib/presentation/screens/main/home_screen.dart)
- Book detail: [lib/presentation/screens/books/book_detail_screen.dart](lib/presentation/screens/books/book_detail_screen.dart)
- Wishlist: [lib/presentation/screens/wishlist/wishlist_screen.dart](lib/presentation/screens/wishlist/wishlist_screen.dart)
- Providers: [lib/presentation/providers](lib/presentation/providers)

## Notes
- This is my mini project submission for Dibimbing.id's Mobile Development Bootcamp
- There might be a newer release pushed after the deadline. I don't exactly know if that counts or not. If not, then ignore it.
- The pitch deck/portfolio slide is located at [docs/codexia-pitch-deck.pdf](docs/codexia-pitch-deck.pdf).

