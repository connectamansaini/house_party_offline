import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.label, this.size = 28});

  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
