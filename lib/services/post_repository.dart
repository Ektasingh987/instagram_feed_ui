import 'dart:math';
import '../models/post.dart';
import '../models/user.dart';
import '../models/story.dart';

class PostRepository {
  final Random _random = Random();

  // Mock Users with stories
  late final List<User> _mockUsers;

  PostRepository() {
    _mockUsers = [
      User(
        id: '1',
        username: 'instagram',
        profileImageUrl: 'https://images.unsplash.com/photo-1611262588024-d12430b98920?w=150',
        isVerified: true,
        hasStory: true,
        stories: [
          Story(id: 's1', imageUrl: 'https://picsum.photos/seed/story1/1080/1920', createdAt: DateTime.now()),
          Story(id: 's2', imageUrl: 'https://picsum.photos/seed/story2/1080/1920', createdAt: DateTime.now()),
        ],
      ),
      User(
        id: '2',
        username: 'nature_lover',
        profileImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        hasStory: true,
        stories: [
          Story(id: 's3', imageUrl: 'https://picsum.photos/seed/story3/1080/1920', createdAt: DateTime.now()),
        ],
      ),
      User(id: '3', username: 'photography_hub', profileImageUrl: 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=150', isVerified: true),
      User(
        id: '4',
        username: 'travel_diaries',
        profileImageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=150',
        hasStory: true,
        stories: [
          Story(id: 's4', imageUrl: 'https://picsum.photos/seed/story4/1080/1920', createdAt: DateTime.now()),
        ],
      ),
      User(id: '5', username: 'foodie_adventures', profileImageUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150'),
    ];
  }

  // Mock Image URLs for Posts
  final List<String> _mockImages = [
    'https://picsum.photos/seed/travel/800/800',
    'https://picsum.photos/seed/nature/800/1000',
    'https://picsum.photos/seed/urban/800/1200',
    'https://picsum.photos/seed/food/1000/800',
    'https://picsum.photos/seed/portrait/800/800',
    'https://picsum.photos/seed/landscape/800/1000',
    'https://picsum.photos/seed/tech/800/1200',
    'https://picsum.photos/seed/animal/1000/800',
    'https://picsum.photos/seed/coffee/800/800',
    'https://picsum.photos/seed/water/800/1000',
  ];

  // Generate a random post
  Post _generateRandomPost(int index) {
    final user = _mockUsers[_random.nextInt(_mockUsers.length)];
    
    // 30% chance of being a carousel (multiple images)
    final bool isCarousel = _random.nextDouble() > 0.7;
    final int imageCount = isCarousel ? _random.nextInt(3) + 2 : 1; // 2-4 images for carousel
    
    List<String> images = [];
    for (int i = 0; i < imageCount; i++) {
        images.add(_mockImages[_random.nextInt(_mockImages.length)]);
    }

    return Post(
      id: DateTime.now().millisecondsSinceEpoch.toString() + index.toString(),
      user: user,
      imageUrls: images,
      caption: 'This is a beautiful amazing mock caption for post $index! #flutter #ui #clone #instagram',
      likesCount: _random.nextInt(10000) + 10,
      commentsCount: _random.nextInt(500) + 1,
      createdAt: DateTime.now().subtract(Duration(hours: _random.nextInt(48))),
      isLiked: false,
      isSaved: false,
    );
  }

  // Fetch initial posts with a 1.5s delay
  Future<List<Post>> fetchInitialPosts({int count = 10}) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.generate(count, (index) => _generateRandomPost(index));
  }

  // Fetch more posts with a 1.5s delay
  Future<List<Post>> fetchMorePosts({int count = 10}) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.generate(count, (index) => _generateRandomPost(index));
  }

  // Get stories tray users
  Future<List<User>> fetchStories() async {
    // Return users that have stories
    return _mockUsers.where((u) => u.hasStory).toList();
  }
}
