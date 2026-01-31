# Catatan Assignment: Distribusi Aplikasi, Testing, dan Debugging
- Testing:
	- Unit: test/data/repositories/book_repository_test.dart, test/data/models/book_model_test.dart.
	- Widget: test/presentation/screens/explore/explore_screen_test.dart, test/presentation/screens/books/book_detail_screen_test.dart.
	- Integration: integration_test/app_test.dart.
- Debug console: Dio interceptor di lib/data/services/api_client.dart untuk logging.
- CI/CD: GitHub Actions [.github/workflows/flutter-ci.yml], dengan flow analyze + test, plus upload Firebase App Distribution otomatis.