import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../../data/models/book_model.dart';
import '../../../data/repositories/book_repository.dart';
import '../../widgets/books/book_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _pageSize = 10;

  final BookRepository _repo = BookRepository();
  final ScrollController _scrollController = ScrollController();

  final List<BookModel> _items = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading || !_hasMore) return;
    final trigger = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= trigger) {
      _loadPage();
    }
  }

  Future<void> _loadPage({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      setState(() {
        _page = 1;
        _hasMore = true;
        _items.clear();
        _error = null;
      });
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await _repo.fetchBooks(page: _page, pageSize: _pageSize);
      setState(() {
        _items.addAll(newItems);
        _hasMore = newItems.length == _pageSize;
        if (_hasMore) _page += 1;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadPage(refresh: true),
          child: Builder(
            builder: (context) {
              if (_items.isEmpty && _isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_items.isEmpty && _error != null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gagal memuat buku',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _loadPage(refresh: true),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (_items.isEmpty) {
                return const Center(
                  child: Text('Belum ada buku untuk ditampilkan.'),
                );
              }

              return ListView.separated(
                controller: _scrollController,
                itemCount: _items.length + (_hasMore ? 1 : 0),
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final book = _items[index];
                  return BookItem(
                    book: book,
                    onTap: () {
                      const tempSnackBar = SnackBar(
                        content: Text('In progress yak'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(tempSnackBar);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: MainNavBar(),
    );
  }
}
