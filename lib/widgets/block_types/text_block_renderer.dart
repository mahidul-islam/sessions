import 'package:flutter/material.dart';
import '../../models/text_block.dart';

class TextBlockRenderer extends StatelessWidget {
  final TextBlock block;

  const TextBlockRenderer({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        block.text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
