class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final bool isVerified;
  final bool hasStory;

  User({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    this.isVerified = false,
    this.hasStory = false,
  });
}
