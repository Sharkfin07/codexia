import 'package:codexia/presentation/theme/app_palette.dart';
import 'package:flutter/material.dart';

import '../../../data/models/book_model.dart';
import '../../../data/repositories/book_repository.dart';
import '../books/book_detail.dart';
import '../../widgets/books/book_item.dart';
import '../../widgets/main/main_nav_bar.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const _pageSize = 10;

  final BookRepository _repo = BookRepository();
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _pageController = TextEditingController(text: '');
  final ScrollController _scrollController = ScrollController();

  final List<BookModel> _items = [];
  List<String> _genres = [];
  String? _selectedGenre;
  BookSort _sort = BookSort.newest;
  bool _filtersOpen = true;

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _loadingGenres = false;
  String? _error;
  String? _genreError;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
    _loadPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _yearController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchGenres() async {
    setState(() {
      _loadingGenres = true;
      _genreError = null;
    });

    try {
      final genres = await _repo.fetchGenres();
      setState(() {
        _genres = genres;
        if (_selectedGenre == null && genres.isNotEmpty) {
          _selectedGenre = null;
        }
      });
    } catch (e) {
      setState(() {
        _genreError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loadingGenres = false);
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading || !_hasMore) return;
    final trigger = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= trigger) {
      _loadPage();
    }
  }

  int _resolveStartPage() {
    final raw = int.tryParse(_pageController.text.trim());
    if (raw == null || raw < 1) return 1;
    return raw;
  }

  int? _resolveYear() {
    final raw = int.tryParse(_yearController.text.trim());
    if (raw == null || raw <= 0) return null;
    return raw;
  }

  String? _resolveKeyword() {
    final raw = _keywordController.text.trim();
    if (raw.isEmpty) return null;
    return raw;
  }

  Future<void> _loadPage({bool refresh = false}) async {
    if (_isLoading) return;

    final startPage = _resolveStartPage();
    if (refresh) {
      setState(() {
        _page = startPage;
        _items.clear();
        _hasMore = true;
        _error = null;
      });
    }

    if (!_hasMore && !refresh) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await _repo.fetchBooks(
        keyword: _resolveKeyword(),
        genre: _selectedGenre,
        year: _resolveYear(),
        sort: _sort,
        page: _page,
        pageSize: _pageSize,
      );

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

  void _applyFilters() {
    FocusScope.of(context).unfocus();
    _loadPage(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Books')),
      body: SafeArea(
        child: Column(
          children: [
            _FiltersCard(
              keywordController: _keywordController,
              yearController: _yearController,
              pageController: _pageController,
              genres: _genres,
              selectedGenre: _selectedGenre,
              loadingGenres: _loadingGenres,
              genreError: _genreError,
              onGenreChanged: (value) => setState(() => _selectedGenre = value),
              onRefreshGenres: _fetchGenres,
              onApply: _applyFilters,
              isOpen: _filtersOpen,
              onToggleOpen: () => setState(() => _filtersOpen = !_filtersOpen),
            ),
            _SortBar(
              sort: _sort,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _sort = value);
                _loadPage(refresh: true);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadPage(refresh: true),
                child: Builder(
                  builder: (context) {
                    if (_items.isEmpty && _isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_items.isEmpty && _error != null) {
                      return _ErrorState(
                        message: 'Failed to load books',
                        detail: _error!,
                        onRetry: () => _loadPage(refresh: true),
                      );
                    }

                    if (_items.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No books match these filters yet. Try adjusting your search.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      itemCount: _items.length + (_hasMore ? 1 : 0),
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        color: AppPalette.darkSecondary,
                      ),
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
                            Navigator.of(context).pushNamed(
                              '/books/detail',
                              arguments: BookDetailArgs(
                                id: book.id,
                                prefetched: book,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavBar(currentIndex: 1),
    );
  }
}

class _FiltersCard extends StatelessWidget {
  const _FiltersCard({
    required this.keywordController,
    required this.yearController,
    required this.pageController,
    required this.genres,
    required this.selectedGenre,
    required this.loadingGenres,
    required this.genreError,
    required this.onGenreChanged,
    required this.onRefreshGenres,
    required this.onApply,
    required this.isOpen,
    required this.onToggleOpen,
  });

  final TextEditingController keywordController;
  final TextEditingController yearController;
  final TextEditingController pageController;
  final List<String> genres;
  final String? selectedGenre;
  final bool loadingGenres;
  final String? genreError;
  final ValueChanged<String?> onGenreChanged;
  final VoidCallback onRefreshGenres;
  final VoidCallback onApply;
  final bool isOpen;
  final VoidCallback onToggleOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppPalette.darkPink,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleOpen,
                    tooltip: isOpen ? 'Collapse filters' : 'Expand filters',
                    icon: Icon(isOpen ? Icons.expand_less : Icons.expand_more),
                  ),
                  // IconButton(
                  //   onPressed: onRefreshGenres,
                  //   tooltip: 'Reload genres',
                  //   icon: const Icon(Icons.refresh_outlined),
                  // ),
                ],
              ),
              AnimatedCrossFade(
                crossFadeState: isOpen
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
                firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: selectedGenre,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Any genre'),
                        ),
                        ...genres.map(
                          (g) => DropdownMenuItem<String?>(
                            value: g,
                            child: Text(g),
                          ),
                        ),
                      ],
                      onChanged: loadingGenres ? null : onGenreChanged,
                      hint: loadingGenres
                          ? const Text('Loading genres...')
                          : const Text('Select genre'),
                    ),
                    if (genreError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          genreError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: keywordController,
                      decoration: const InputDecoration(
                        labelText: 'Keyword',
                        hintText: 'e.g., adventure, mystery',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => onApply(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: yearController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              hintText: 'e.g., 2024',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => onApply(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: pageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Page',
                              hintText: '1',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => onApply(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onApply,
                        icon: const Icon(Icons.tune_outlined),
                        label: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({required this.sort, required this.onChanged});

  final BookSort sort;
  final ValueChanged<BookSort?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text('Sort by'),
          const SizedBox(width: 12),
          DropdownButton<BookSort>(
            value: sort,
            onChanged: onChanged,
            items: BookSort.values
                .map(
                  (s) => DropdownMenuItem<BookSort>(
                    value: s,
                    child: Text(_labelForSort(s)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

String _labelForSort(BookSort sort) {
  switch (sort) {
    case BookSort.newest:
      return 'Newest';
    case BookSort.oldest:
      return 'Oldest';
    case BookSort.titleAZ:
      return 'Title A-Z';
    case BookSort.titleZA:
      return 'Title Z-A';
    case BookSort.priceLowHigh:
      return 'Price Low-High';
    case BookSort.priceHighLow:
      return 'Price High-Low';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
