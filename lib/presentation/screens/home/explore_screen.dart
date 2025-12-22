import 'package:flutter/material.dart';

import '../../../data/models/book_model.dart';
import '../../../data/repository/book_repository.dart';
import '../../widgets/books/book_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final BookRepository _repo;
  late final Future<List<BookModel>> _future;

  @override
  void initState() {
    super.initState();
    _repo = BookRepository();
    _future = _repo.fetchBooks(pageSize: 10);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Showcase Testing')),
      body: FutureBuilder<List<BookModel>>(
        future: _future,
        // TODO: Implement infinite scroll
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
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
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(() {
                      _future = _repo.fetchBooks(pageSize: 10);
                    }),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(
              child: Text('Belum ada buku untuk ditampilkan.'),
            );
          }

          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookItem(
                book: book,
                onTap: () {
                  // TODO: navigate to detail page

                  // ! Temp snackbar, hapus saat di production
                  const tempSnackBar = SnackBar(
                    content: Text("In progress yak"),
                    duration: Duration(seconds: 3),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(tempSnackBar);
                  // !
                },
              );
            },
          );
        },
      ),
    );
  }
}
