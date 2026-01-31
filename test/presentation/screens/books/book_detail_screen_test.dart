// * Widget Testing 1: Book Detail Screen Integrity and Toggle Test
import 'package:codexia/data/models/book_model.dart';
import 'package:codexia/data/models/wishlist_item_model.dart';
import 'package:codexia/presentation/providers/book_detail_provider.dart';
import 'package:codexia/presentation/providers/wishlist_provider.dart';
import 'package:codexia/presentation/screens/books/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Wishlist notifier ringan
class _FakeWishlistNotifier extends WishlistNotifier {
  _FakeWishlistNotifier({List<WishlistItemModel>? initial})
    : _initial = initial ?? [];

  final List<WishlistItemModel> _initial;
  int toggleCalls = 0;

  @override
  Future<List<WishlistItemModel>> build() async => _initial;

  @override
  Future<void> toggle(BookModel book) async {
    toggleCalls++;
    final current = state.value ?? _initial;
    final exists = current.any((w) => w.id == book.id);
    final updated = exists
        ? current.where((w) => w.id != book.id).toList()
        : [
            WishlistItemModel(
              id: book.id,
              title: book.title,
              coverUrl: book.coverUrl,
              addedAt: DateTime(2024, 1, 1),
            ),
            ...current,
          ];
    state = AsyncData(updated);
  }

  @override
  Future<void> removeById(String bookId) async {
    final current = state.value ?? _initial;
    state = AsyncData(current.where((w) => w.id != bookId).toList());
  }
}

// Placeholder book
BookModel _fakeBook() {
  return BookModel(
    id: 'bk-99',
    title: 'Widget Testing in Action',
    coverUrl: 'https://example.com/widget.png',
    authorName: 'Dev Tester',
    category: 'Education',
    summary: 'Learn how to write widget tests effectively.',
    price: 'Rp 25.000',
    totalPages: 200,
    publishedDate: DateTime(2023, 10, 12),
    publisher: 'QA Press',
  );
}

void main() {
  testWidgets('Detail rendering and wishlist toggling', (tester) async {
    final book = _fakeBook();
    final fakeWishlist = _FakeWishlistNotifier(initial: []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookDetailProvider.overrideWith((ref, id) async => book),
          wishlistProvider.overrideWith(() => fakeWishlist),
        ],
        child: MaterialApp(
          home: BookDetailScreen(id: book.id, initialBook: book),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(book.title), findsOneWidget);
    expect(find.text('by ${book.authorName}'), findsOneWidget);
    expect(find.text(book.category), findsOneWidget);
    expect(find.text('Rent'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to wishlist'));
    await tester.pump();

    expect(fakeWishlist.toggleCalls, 1);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
