// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../models/session_model.dart';
// import '../models/text_block.dart';

// class CommandInput extends StatefulWidget {
//   const CommandInput({Key? key}) : super(key: key);

//   @override
//   State<CommandInput> createState() => _CommandInputState();
// }

// class _CommandInputState extends State<CommandInput> {
//   late TextEditingController _controller;
//   late FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//     _focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sessionModel = Provider.of<SessionModel>(context);

//     // Update controller if command changed from outside
//     if (sessionModel.currentCommand != _controller.text) {
//       _controller.text = sessionModel.currentCommand;
//       // Move cursor to end
//       _controller.selection = TextSelection.fromPosition(
//         TextPosition(offset: _controller.text.length),
//       );
//     }

//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 8,
//             color: Colors.black.withOpacity(0.2),
//           ),
//         ],
//       ),
//       child: KeyboardListener(
//         focusNode: FocusNode(), // Secondary focus node just for keyboard events
//         onKeyEvent: (event) {
//           if (event is KeyDownEvent) {
//             // Shift + Enter
//             if (event.logicalKey == LogicalKeyboardKey.enter &&
//                 (event.physicalKey == PhysicalKeyboardKey.shiftLeft ||
//                     event.physicalKey == PhysicalKeyboardKey.shiftRight)) {
//               final value = _controller.text;
//               final textBlock = TextBlock(text: value.isEmpty ? '' : value);
//               sessionModel.addBlock(textBlock);
//               sessionModel.setCurrentCommand('');
//               _controller.clear();
//             }

//             // Backspace on empty
//             if (event.logicalKey == LogicalKeyboardKey.backspace &&
//                 _controller.text.isEmpty &&
//                 sessionModel.focusedBlockIndex > 0) {
//               sessionModel
//                   .setFocusedBlockIndex(sessionModel.focusedBlockIndex - 1);
//             }
//           }
//         },
//         child: TextField(
//           controller: _controller,
//           focusNode: _focusNode, // Main focus node for the TextField
//           style: const TextStyle(fontSize: 16),
//           decoration: InputDecoration(
//             hintText: 'Type / for commands or start typing',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//             prefixIcon: _controller.text.startsWith('/')
//                 ? const Icon(Icons.code)
//                 : const Icon(Icons.text_fields),
//             suffixIcon: _controller.text.isNotEmpty
//                 ? IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       _controller.clear();
//                       sessionModel.setCurrentCommand('');
//                     },
//                   )
//                 : null,
//           ),
//           onChanged: (value) {
//             sessionModel.setCurrentCommand(value);
//           },
//           onSubmitted: (value) {
//             if (value.isNotEmpty) {
//               if (value.startsWith('/')) {
//                 sessionModel.convertCommandToBlock();
//               } else {
//                 final textBlock = TextBlock(text: value);
//                 final focusedIndex = sessionModel.focusedBlockIndex;
//                 if (focusedIndex >= 0 &&
//                     focusedIndex < sessionModel.blocks.length) {
//                   sessionModel.insertBlockAt(focusedIndex + 1, textBlock);
//                 } else {
//                   sessionModel.addBlock(textBlock);
//                 }
//                 sessionModel.setCurrentCommand('');
//               }
//               _focusNode.requestFocus();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
