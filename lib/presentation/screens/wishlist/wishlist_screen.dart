import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/wishlist_item_model.dart';
import '../../providers/wishlist_provider.dart';
import '../books/book_detail_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: state.when(
        data: (items) => _WishlistList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
      ),
    );
  }
}

class _WishlistList extends ConsumerWidget {
  const _WishlistList({required this.items});
  final List<WishlistItemModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No wishlist items yet. Start adding your favorites!'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.coverUrl,
              width: 48,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            'Added on ${item.addedAt.toLocal().toString().split(' ').first}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                ref.read(wishlistProvider.notifier).removeById(item.id),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/books/detail',
              arguments: BookDetailArgs(id: item.id),
            );
          },
        );
      },
    );
  }
}
