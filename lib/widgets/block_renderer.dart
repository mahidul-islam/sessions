import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/block.dart';
import '../models/circuit_block.dart';
import '../models/interval_block.dart';
import '../models/session_model.dart';
import '../models/text_block.dart';
import '../models/workout_block.dart';
import 'block_types/circuit_block_renderer.dart';
import 'block_types/interval_block_renderer.dart';
import 'block_types/text_block_renderer.dart';
import 'block_types/workout_block_renderer.dart';

class BlockRenderer extends StatelessWidget {
  final Block block;
  final int index;
  final bool isFocused;

  BlockRenderer({
    Key? key,
    required this.block,
    required this.index,
    required this.isFocused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: isFocused
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            sessionModel.setFocusedBlockIndex(index);
          }
        },
        child: GestureDetector(
          onTap: () => sessionModel.setFocusedBlockIndex(index),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDragHandle(context),
              Expanded(
                child: _buildBlockContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context, listen: false);

    return GestureDetector(
      onTap: _showBlockMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Icon(
          Icons.drag_indicator,
          size: 20,
          color:
              isFocused ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBlockContent(BuildContext context) {
    if (block is TextBlock) {
      return TextBlockRenderer(block: block as TextBlock);
    } else if (block is IntervalBlock) {
      return IntervalBlockRenderer(block: block as IntervalBlock);
    } else if (block is CircuitBlock) {
      return CircuitBlockRenderer(block: block as CircuitBlock);
    } else if (block is WorkoutBlock) {
      return WorkoutBlockRenderer(block: block as WorkoutBlock);
    }

    // Fallback
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text('Unknown block type: ${block.runtimeType}'),
    );
  }

  void _showBlockMenu() {
    final context = _dragHandleKey.currentContext;
    if (context == null) return;

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final sessionModel = Provider.of<SessionModel>(context, listen: false);

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
          onTap: () => sessionModel.removeBlockAt(index),
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.content_copy, size: 20),
              SizedBox(width: 8),
              Text('Duplicate'),
            ],
          ),
          onTap: () => sessionModel.duplicateBlockAt(index),
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Edit as command'),
            ],
          ),
          onTap: () => sessionModel.convertBlockToCommand(index),
        ),
      ],
    );
  }

  final GlobalKey _dragHandleKey = GlobalKey();
}
