import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_repository.dart';

class FeedProvider with ChangeNotifier {
  final PostRepository _repository = PostRepository();

  List<Post> _posts = [];
  List<User> _stories = [];
  bool _isLoadingInitial = true;
  bool _isFetchingMore = false;
  bool _hasError = false;

  List<Post> get posts => _posts;
  List<User> get stories => _stories;
  bool get isLoadingInitial => _isLoadingInitial;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasError => _hasError;

  FeedProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      _isLoadingInitial = true;
      _hasError = false;
      notifyListeners();

      // Fetch stories and initial posts simultaneously
      final results = await Future.wait([
        _repository.fetchStories(),
        _repository.fetchInitialPosts(count: 10),
      ]);

      _stories = results[0] as List<User>;
      _posts = results[1] as List<Post>;
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoadingInitial = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isFetchingMore || _isLoadingInitial) return;

    try {
      _isFetchingMore = true;
      notifyListeners();

      final newPosts = await _repository.fetchMorePosts(count: 10);
      _posts.addAll(newPosts);
    } catch (e) {
      // Handle error gracefully
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      post.isLiked = !post.isLiked;
      if (post.isLiked) {
        post.likesCount++;
      } else {
        post.likesCount--;
      }
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      post.isSaved = !post.isSaved;
      notifyListeners();
    }
  }
}
