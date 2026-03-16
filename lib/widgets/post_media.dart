import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/post.dart';
import 'zoom_overlay.dart';

class PostMedia extends StatefulWidget {
  final Post post;

  const PostMedia({super.key, required this.post});

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  Future<void> _handleDoubleTap() async {
    // Like animation logic could go here
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Simplified GestureDetector to avoid conflict with Pinch-to-Zoom
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: widget.post.imageUrls.length > 1
              ? _buildCarousel()
              : _buildSingleImage(widget.post.imageUrls.first),
        ),
        if (widget.post.imageUrls.length > 1) ...[
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: _currentImageIndex,
            count: widget.post.imageUrls.length,
            effect: const ScrollingDotsEffect(
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
              dotHeight: 6,
              dotWidth: 6,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.post.imageUrls.length,
      itemBuilder: (context, index, realIndex) {
        return _buildPinchToZoomImage(widget.post.imageUrls[index]);
      },
      options: CarouselOptions(
        aspectRatio: 1.0, // Instagram standard square or 4:5
        viewportFraction: 1.0, // Full width per image
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentImageIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: _buildPinchToZoomImage(imageUrl),
    );
  }

  Widget _buildPinchToZoomImage(String imageUrl) {
    return ZoomOverlay(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[100],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 40),
              const SizedBox(height: 8),
              Text(
                'Image Unavailable',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
