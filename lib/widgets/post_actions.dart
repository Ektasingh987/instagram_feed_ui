import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';

class PostActions extends StatelessWidget {
  final Post post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : Colors.black,
                  size: 28,
                ),
                onPressed: () {
                  context.read<FeedProvider>().toggleLike(post.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comments (Not implemented)')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share (Not implemented)')),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
               context.read<FeedProvider>().toggleSave(post.id);
            },
          )
        ],
      ),
    );
  }
}
