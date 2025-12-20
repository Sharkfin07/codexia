# Litera

## Progress (Sudah dikerjakan)
- Integrasi Buku Acak API via Dio di [lib/data/repository/book_repository.dart](lib/data/repository/book_repository.dart) (list + detail, sort, pagination parameter `page`).
- Normalisasi URL cover di [lib/data/models/book_model.dart](lib/data/models/book_model.dart) agar gambar tidak gagal karena skema/spasi.
- Widget daftar buku [lib/presentation/widgets/books/book_item.dart](lib/presentation/widgets/books/book_item.dart) dengan placeholder, loading indicator, dan handling error gambar.
- Layar Jelajah awal [lib/presentation/screens/home/jelajah_screen.dart](lib/presentation/screens/home/jelajah_screen.dart) menampilkan 10 buku pertama dengan loader/error/empty state.
- Penyesuaian base URL Buku Acak sesuai dokumentasi `https://bukuacak-9bdcb4ef2605.herokuapp.com/api/v1`.

## Roadmap
- Desain guide dan identitas aplikasi.
- Navigasi ke detail buku + layar detail (buy link, rent CTA).
- State management (mis. Riverpod/BLoC) untuk books, auth, wishlist, rentals.
- Integrasi Firebase Auth + Firestore (user profile, rentals, wishlist).
- Form sewa (1–7 hari, harga Rp 5.000/hari) dan daftar sewa dengan status/renew.
- Wishlist add/remove dan tanda isWishlisted.
- Search/filter/sort UI, pagination atau load-more untuk daftar buku.
- Error handling konsisten (snackbar), loader overlay untuk API/Firebase.
- README final + aset build dan mungkin video demo.
