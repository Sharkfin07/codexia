import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/book_model.dart';
import '../../../presentation/providers/book_detail_provider.dart';

class BookDetailArgs {
  const BookDetailArgs({required this.id, this.prefetched});

  final String id;
  final BookModel? prefetched;
}

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.id, this.initialBook});

  final String id;
  final BookModel? initialBook;

  static BookDetailScreen fromRoute(Object? arguments) {
    if (arguments is BookDetailArgs) {
      return BookDetailScreen(
        id: arguments.id,
        initialBook: arguments.prefetched,
      );
    }

    if (arguments is BookModel) {
      return BookDetailScreen(id: arguments.id, initialBook: arguments);
    }

    if (arguments is String && arguments.isNotEmpty) {
      return BookDetailScreen(id: arguments);
    }

    return const BookDetailScreen(id: '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id.isEmpty) {
      return const Scaffold(body: Center(child: Text('Book id is missing')));
    }

    final asyncDetail = ref.watch(bookDetailProvider(id));
    final fallback = initialBook;

    return Scaffold(
      appBar: AppBar(title: Text(fallback?.title ?? 'Book Detail')),
      body: asyncDetail.when(
        data: (book) => _DetailBody(
          book: book,
          onRefresh: () async {
            ref.invalidate(bookDetailProvider(id));
            await ref.read(bookDetailProvider(id).future);
          },
        ),
        loading: () => _DetailBody(
          book: fallback,
          isLoading: true,
          onRefresh: () async {
            ref.invalidate(bookDetailProvider(id));
            await ref.read(bookDetailProvider(id).future);
          },
        ),
        error: (e, _) => _ErrorState(
          message: 'Gagal memuat detail buku',
          detail: e.toString(),
          onRetry: () => ref.invalidate(bookDetailProvider(id)),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.book,
    this.isLoading = false,
    this.onRefresh,
  });

  final BookModel? book;
  final bool isLoading;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cover(url: book!.coverUrl, isLoading: isLoading),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book!.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'by ${book!.authorName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          label: book!.category,
                          icon: Icons.category_outlined,
                        ),
                        _MetaChip(
                          label: book!.publisher,
                          icon: Icons.business_outlined,
                        ),
                        _MetaChip(
                          label: _formatDate(book!.publishedDate),
                          icon: Icons.calendar_month_outlined,
                        ),
                        _MetaChip(
                          label: '${book!.totalPages} pages',
                          icon: Icons.menu_book_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PriceTag(price: book!.price),
          const SizedBox(height: 16),
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(book!.summary, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url, this.isLoading = false});

  final String url;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 130,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: isLoading
              ? Container(color: Colors.grey.shade200)
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.book_outlined, size: 48),
                  ),
                ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.local_offer_outlined, color: Colors.green.shade700),
        const SizedBox(width: 6),
        Text(
          price,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.green.shade800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.detail,
    required this.onRetry,
  });

  final String message;
  final String detail;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(detail, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
