import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      key: const Key('skeleton_list'),
      shrinkWrap: true,
      children: [
        _buildSkeletonCard(context, size),
        _buildSkeletonCard(context, size),
      ],
    );
  }

  Widget _buildSkeletonCard(BuildContext context, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      constraints: BoxConstraints(
        minHeight: size.height * 0.35,
        maxHeight: size.height * 0.45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade400,
        child: ListView(
          children: [
            Container(
              height: size.height * 0.2,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 20,
              width: size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: size.height * 0.11,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
