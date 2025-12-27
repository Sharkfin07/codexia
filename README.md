# Codexia

## Gambaran Umum
Codexia adalah aplikasi Flutter untuk eksplorasi, sewa, dan wishlist buku. Menggunakan Riverpod serta Firebase Auth dan Firestore.

## Progres
- **Alur autentikasi**: Layar masuk, daftar, reset sandi, dan edit profil terhubung ke `authService` via Riverpod.
- **Beranda**: Sapaan sesuai waktu, mengambil display name (fallback ke bagian awal email). Ada kartu aksi cepat bergradasi: Quick Explore (filter), My Rentals, My Wishlists.
- **Navigasi**: Bottom navigation bar (Home, Explore, Rentals, Profile) menggunakan package [google_nav_bar](https://pub.dev/packages/google_nav_bar). Rute tambahan untuk wishlist, filter, detail buku, dan sewa.
- **Eksplorasi/Filter**: Layar filter dapat diakses dari Explore dan aksi cepat Home.
- **Detail Buku**: Data dari `bookDetailProvider`; menampilkan metadata, harga, ringkasan, tombol Buy (pencarian web) dan Rent. Toggle wishlist hanya di ikon hati AppBar.
- **Wishlist**: `wishlistProvider` menampilkan daftar, bisa hapus, tap ke detail; tarik-untuk-refresh dengan `ref.refresh(wishlistProvider.future)`.
- **Rentals**: Layar sewa tersedia; alur sewa via `/books/rent` dan tab Rentals.
- **Tema**: Light/dark via `AppTheme`; warna brand di `AppPalette`; kartu aksi cepat memakai gradient.

## Arsitektur (Tree)
```
Codexia (Flutter app)
├─ main.dart (boot + routes + ProviderScope)
├─ presentation/
│  ├─ screens/
│  │  ├─ auth/ (sign-in, sign-up, reset, edit profile)
│  │  ├─ main/ (home, explore, rental, profile)
│  │  ├─ books/ (book_detail)
│  │  └─ wishlist/ (wishlist_screen)
│  ├─ providers/ (auth, book_detail, wishlist, rental)
│  ├─ widgets/ (global UI, main nav bar, book items)
│  └─ theme/ (app_palette, app_theme)
├─ data/
│  ├─ models/ (book, rental, user, wishlist_item)
│  ├─ repositories/ (book, rental, wishlist)
│  └─ services/ (auth_service, book_service, firestore_service, api_client)
└─ external
	├─ Firebase Auth (user/session)
	└─ Firestore (books, rentals, wishlist)
```

## Teknologi & Dependensi
- Flutter
- Riverpod 3 (flutter_riverpod, riverpod_annotation + generator)
- Firebase: firebase_core, firebase_auth, cloud_firestore
- Jaringan & utilitas: dio, url_launcher
- UI: google_nav_bar, flutter_svg, font Poppins

## Menjalankan Lokal
1) Pastikan Flutter terpasang dan platform (Android/iOS) siap.
2) Firebase sudah dikaitkan (`firebase_options.dart`; butuh `google-services.json` / `GoogleService-Info.plist`).
3) Ambil paket: `flutter pub get`
4) Jalankan: `flutter run`

## Peta Rute
- Root: Home bila sudah login, jika tidak ke Sign In
- `/sign-in`, `/sign-up`, `/forgot-password`, `/profile`, `/profile/edit`, `/profile/reset-password`
- `/explore`, `/explore/filter`
- `/books/detail`
- `/books/rent`
- `/wishlist`
- `/rental`