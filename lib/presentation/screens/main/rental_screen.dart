import 'package:codexia/presentation/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/rental_model.dart';

import '../../providers/rental_provider.dart';
import '../../widgets/main/main_nav_bar.dart';
import '../books/book_detail_screen.dart';

class RentalScreen extends ConsumerStatefulWidget {
  const RentalScreen({super.key});

  @override
  ConsumerState<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends ConsumerState<RentalScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch on first open to avoid empty state if provider was disposed.
    Future.microtask(() => ref.read(rentalProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    return Scaffold(
      body: SafeArea(
        child: state.when(
          data: (items) => RefreshIndicator(
            onRefresh: () => ref.read(rentalProvider.notifier).refresh(),
            child: _RentalList(items: items),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => RefreshIndicator(
            onRefresh: () => ref.read(rentalProvider.notifier).refresh(),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Failed to load rentals: $e'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainNavBar(currentIndex: 2),
    );
  }
}

class _RentalList extends ConsumerWidget {
  const _RentalList({required this.items});
  final List<RentalModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No rentals yet. Borrow a book to see it here.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppPalette.darkSecondary),
      itemBuilder: (context, index) {
        final rental = items[index];
        final effectiveStatus = rental.effectiveStatus;
        final isActive = effectiveStatus == RentalStatus.active;
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              rental.coverUrl,
              width: 48,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 48,
                height: 72,
                color: Colors.grey.shade300,
                child: const Icon(Icons.book_outlined, size: 28),
              ),
            ),
          ),
          title: Text(
            rental.bookTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isActive
                    ? 'Due: ${_formatDate(rental.dueDate)}'
                    : 'Returned: ${rental.returnedAt != null ? _formatDate(rental.returnedAt!) : '-'}',
              ),
              const SizedBox(height: 4),
              Text(
                '${rental.rentalDays} day(s) • ${_formatCurrency(rental.totalPrice)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              _StatusChip(status: effectiveStatus),
            ],
          ),
          trailing: isActive
              ? TextButton(
                  onPressed: () => ref
                      .read(rentalProvider.notifier)
                      .markReturned(rental.rentalId),
                  child: const Text('Return'),
                )
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/books/detail',
                      arguments: BookDetailArgs(id: rental.bookId),
                    );
                  },
                  child: const Text('Rent again'),
                ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/books/detail',
              arguments: BookDetailArgs(id: rental.bookId),
            );
          },
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RentalStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case RentalStatus.active:
        color = Colors.blue;
        label = 'Active';
        break;
      case RentalStatus.overdue:
        color = Colors.red;
        label = 'Overdue';
        break;
      case RentalStatus.returned:
        color = Colors.green;
        label = 'Returned';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return date.toLocal().toString().split(' ').first;
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
