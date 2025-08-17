import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';

class LoadingList extends StatelessWidget {
  const LoadingList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: 6,
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
        title: _shimmerBox(height: 16, width: 180, context: context),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _shimmerBox(height: 14, width: 260, context: context),
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
        color: context.colorScheme.surface.withValues(
          red: 200,
          green: 200,
          blue: 200,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
