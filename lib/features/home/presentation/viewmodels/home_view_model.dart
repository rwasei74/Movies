import 'package:flutter/foundation.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_featured_movies.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._getFeaturedMovies);
  final GetFeaturedMovies _getFeaturedMovies;
  bool isLoading = false;
  String? errorMessage;
  List<Movie> movies = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      movies = await _getFeaturedMovies();
    } catch (_) {
      errorMessage = 'تعذر تحميل الأفلام حالياً.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
