import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';

class LoadingList extends StatelessWidget {
  const LoadingList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: 3,
      itemBuilder: (_, __) => const _LoadingTile(),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: _shimmerBox(
          height: 16,
          width: context.mediaQueryWidth * 0.5,
          context: context,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _shimmerBox(
            height: 14,
            width: context.mediaQueryWidth * 0.7,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required BuildContext context,
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade600,
      ),
    );
  }
}
