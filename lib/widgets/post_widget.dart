import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_header.dart';
import '../widgets/post_media.dart';
import '../widgets/post_actions.dart';
import '../widgets/post_details.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostHeader(user: post.user),
        PostMedia(post: post),
        PostActions(post: post),
        PostDetails(post: post),
        const SizedBox(height: 16),
      ],
    );
  }
}
