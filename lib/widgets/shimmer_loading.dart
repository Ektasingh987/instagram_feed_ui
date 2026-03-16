import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, // Show 3 skeleton posts
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 120,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // Media Aspect Ratio Shimmer
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(color: Colors.white),
              ),
              // Actions Shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 16),
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 16),
                    Container(width: 24, height: 24, color: Colors.white),
                    const Spacer(),
                    Container(width: 24, height: 24, color: Colors.white),
                  ],
                ),
              ),
              // Details Shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 14, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(width: double.infinity, height: 14, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: MediaQuery.of(context).size.width * 0.7, height: 14, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
