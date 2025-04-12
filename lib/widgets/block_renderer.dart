import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:session/widgets/command_suggestions.dart';
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

class BlockRenderer extends StatefulWidget {
  final Block block;
  final int index;
  final bool isFocused;

  const BlockRenderer({
    Key? key,
    required this.block,
    required this.index,
    required this.isFocused,
  }) : super(key: key);

  @override
  State<BlockRenderer> createState() => _BlockRendererState();
}

class _BlockRendererState extends State<BlockRenderer> {
  late TextEditingController _commandController;
  late FocusNode _textFieldFocusNode;
  late FocusNode _keyboardListenerFocusNode; // Add a second focus node

  bool _isEditingCommand = false;
  final GlobalKey _blockKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _commandController = TextEditingController();
    _textFieldFocusNode = FocusNode();
    _keyboardListenerFocusNode = FocusNode();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _commandController.dispose();
    _textFieldFocusNode.dispose();
    _keyboardListenerFocusNode.dispose(); // Dispose the new focus node

    super.dispose();
  }

// Focus change handler
  void _onFocusChange() {
    if (!_textFieldFocusNode.hasFocus && _isEditingCommand) {
      // Add a small delay to prevent issues with suggestion selection
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isEditingCommand && !_textFieldFocusNode.hasFocus) {
          _cancelEditing();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context);

    // If this is a newly created block, start in edit mode
    if (widget.isFocused &&
        widget.block is TextBlock &&
        (widget.block as TextBlock).text.isEmpty &&
        !_isEditingCommand) {
      // Use a post-frame callback to start editing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startCommandEditing();
        }
      });
    }

    return PortalTarget(
      visible: _isEditingCommand && sessionModel.showCommandSuggestions,
      portalFollower: IgnorePointer(
        ignoring: false,
        child: CommandSuggestions(
          currentCommand: sessionModel.currentCommand,
          onSuggestionSelected: (suggestion) {
            _commandController.text = suggestion;
            sessionModel.setCurrentCommand(suggestion);
            // _focusNode.requestFocus();
          },
        ),
      ),
      // Use alignment to position the suggestions
      anchor: const Aligned(
        follower: Alignment.bottomCenter,
        target: Alignment.topCenter,
      ),
      child: Container(
        key: _blockKey,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: widget.isFocused
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _isEditingCommand
            ? _buildCommandEditor(context, sessionModel)
            : _buildBlockView(context, sessionModel),
      ),
    );
  }

  Widget _buildBlockView(BuildContext context, SessionModel sessionModel) {
    return GestureDetector(
      onTap: () => sessionModel.setFocusedBlockIndex(widget.index),
      onDoubleTap: _startCommandEditing,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(context, sessionModel),
          Expanded(
            child: _buildBlockContent(context),
          ),
        ],
      ),
    );
  }

  void _startCommandEditing() {
    final sessionModel = Provider.of<SessionModel>(context, listen: false);
    _commandController.text = widget.block.toCommandString();
    sessionModel.setCurrentCommand(_commandController.text);

    setState(() {
      _isEditingCommand = true;
    });

    // Request focus after render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFieldFocusNode.requestFocus(); // Use the text field focus node
    });

    // Notify model of command position for suggestions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_blockKey.currentContext != null) {
        final RenderBox box =
            _blockKey.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        sessionModel.setCommandEditorPosition(position.dy + box.size.height);
      }
    });
  }

  Widget _buildCommandEditor(BuildContext context, SessionModel sessionModel) {
    return RawKeyboardListener(
      focusNode:
          _keyboardListenerFocusNode, // Use the keyboard listener focus node

      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            _cancelEditing();
          } else if (event.logicalKey == LogicalKeyboardKey.backspace &&
              _commandController.text.isEmpty) {
            _cancelEditing();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _commandController,
          focusNode: _textFieldFocusNode, // Use the text field focus node

          decoration: InputDecoration(
            hintText: 'Type / for commands or enter text',
            border: InputBorder.none,
            prefixIcon: _commandController.text.startsWith('/')
                ? const Icon(Icons.code)
                : const Icon(Icons.text_fields),
          ),
          onChanged: (value) {
            sessionModel.setCurrentCommand(value);
          },
          onSubmitted: (value) {
            if (value.isEmpty) {
              _cancelEditing();
              return;
            }

            if (value.startsWith('/')) {
              sessionModel.convertCommandToBlock();
            } else {
              // Create text block
              final textBlock = TextBlock(text: value);
              sessionModel.updateBlockAt(widget.index, textBlock);
            }

            setState(() {
              _isEditingCommand = false;
            });
            sessionModel.setCurrentCommand('');
          },
        ),
      ),
    );
  }

  void _cancelEditing() {
    final sessionModel = Provider.of<SessionModel>(context, listen: false);
    setState(() {
      _isEditingCommand = false;
    });
    sessionModel.setCurrentCommand('');
  }

  Widget _buildDragHandle(BuildContext context, SessionModel sessionModel) {
    return GestureDetector(
      onTap: _showBlockMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Icon(
          Icons.drag_indicator,
          size: 20,
          color: widget.isFocused
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBlockContent(BuildContext context) {
    if (widget.block is TextBlock) {
      return TextBlockRenderer(block: widget.block as TextBlock);
    } else if (widget.block is IntervalBlock) {
      return IntervalBlockRenderer(block: widget.block as IntervalBlock);
    } else if (widget.block is CircuitBlock) {
      return CircuitBlockRenderer(block: widget.block as CircuitBlock);
    } else if (widget.block is WorkoutBlock) {
      return WorkoutBlockRenderer(block: widget.block as WorkoutBlock);
    }

    // Fallback
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text('Unknown block type: ${widget.block.runtimeType}'),
    );
  }

  void _showBlockMenu() {
    final sessionModel = Provider.of<SessionModel>(context, listen: false);

    showMenu(
      context: context,
      position: RelativeRect.fill,
      items: [
        PopupMenuItem(
          onTap: _startCommandEditing,
          child: const Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Edit as command'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => sessionModel.removeBlockAt(widget.index),
          child: const Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => sessionModel.duplicateBlockAt(widget.index),
          child: const Row(
            children: [
              Icon(Icons.content_copy, size: 20),
              SizedBox(width: 8),
              Text('Duplicate'),
            ],
          ),
        ),
      ],
    );
  }
}
