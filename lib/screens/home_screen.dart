import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/top_bar.dart';
import '../widgets/story_tray.dart';
import '../widgets/post_widget.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 1000) {
      // Fetch more when near the bottom (roughly 2 posts away, assuming 500px per post)
      context.read<FeedProvider>().loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TopBar(),
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingInitial) {
            return const ShimmerLoading();
          }

          if (provider.hasError && provider.posts.isEmpty) {
            return const Center(child: Text('Error loading feed.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Ignore for now, stick to infinite scroll requirements
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: StoryTray(stories: provider.stories),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == provider.posts.length) {
                        return provider.isFetchingMore 
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      return PostWidget(post: provider.posts[index]);
                    },
                    childCount: provider.posts.length + 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
