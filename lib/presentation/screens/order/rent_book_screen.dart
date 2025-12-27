import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/book_model.dart';
import '../../providers/rental_provider.dart';

class RentBookArgs {
  const RentBookArgs({required this.book});

  final BookModel book;
}

class RentBookScreen extends ConsumerStatefulWidget {
  const RentBookScreen({super.key, required this.book});

  final BookModel book;

  static RentBookScreen fromRoute(Object? args) {
    if (args is RentBookArgs) {
      return RentBookScreen(book: args.book);
    }
    if (args is BookModel) {
      return RentBookScreen(book: args);
    }
    return RentBookScreen(book: _InvalidBook());
  }

  @override
  ConsumerState<RentBookScreen> createState() => _RentBookScreenState();
}

class _RentBookScreenState extends ConsumerState<RentBookScreen> {
  int _days = 3;
  bool _isSubmitting = false;
  static const int _pricePerDay = 5000;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    if (book is _InvalidBook) {
      return const Scaffold(body: Center(child: Text('Book data is missing.')));
    }

    final totalPrice = _days * _pricePerDay;

    return Scaffold(
      appBar: AppBar(title: const Text('Rent Book')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookSummary(book: book),
                    const SizedBox(height: 16),
                    Text(
                      'Select duration (days)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: _days.toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: '$_days day(s)',
                      onChanged: (value) =>
                          setState(() => _days = value.toInt()),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price per day'),
                        Text(_formatCurrency(_pricePerDay)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Duration'), Text('$_days day(s)')],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total to pay',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _formatCurrency(totalPrice),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : () => _submit(book),
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.playlist_add_check),
                        label: Text(
                          _isSubmitting ? 'Processing...' : 'Confirm Rent',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit(BookModel book) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(rentalProvider.notifier).rent(book, days: _days);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rental created successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/rental');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to rent: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _BookSummary extends StatelessWidget {
  const _BookSummary({required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            book.coverUrl,
            width: 90,
            height: 130,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 90,
              height: 130,
              color: Colors.grey.shade300,
              child: const Icon(Icons.book_outlined, size: 36),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text('by ${book.authorName}'),
              const SizedBox(height: 6),
              Text('Category: ${book.category}'),
            ],
          ),
        ),
      ],
    );
  }
}

String _formatCurrency(int amount) {
  final text = amount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    final reverseIndex = text.length - i - 1;
    buffer.write(text[reverseIndex]);
    if ((i + 1) % 3 == 0 && i != text.length - 1) {
      buffer.write('.');
    }
  }
  final formatted = buffer.toString().split('').reversed.join();
  return 'Rp $formatted';
}

// Marker class to avoid nullable route args
class _InvalidBook extends BookModel {
  _InvalidBook()
    : super(
        id: '',
        title: '',
        coverUrl: '',
        authorName: '',
        category: '',
        summary: '',
        price: '',
        totalPages: 0,
        publishedDate: DateTime(1970),
        publisher: '',
      );
}
