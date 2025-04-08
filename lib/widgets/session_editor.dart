import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session_model.dart';
import 'block_renderer.dart';
import 'command_suggestions.dart';

class SessionEditor extends StatelessWidget {
  const SessionEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context);

    return Stack(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: sessionModel.blocks.length +
                      1, // +1 for "Add new block" button
                  itemBuilder: (context, index) {
                    if (index == sessionModel.blocks.length) {
                      // Add new block button at the end
                      return _buildAddBlockButton(context, sessionModel);
                    }

                    return BlockRenderer(
                      block: sessionModel.blocks[index],
                      index: index,
                      isFocused: index == sessionModel.focusedBlockIndex,
                    );
                  },
                ),
              ),
              _buildSessionSummary(context, sessionModel),
            ],
          ),
        ),

        // Show command suggestions when needed
        if (sessionModel.showCommandSuggestions &&
            sessionModel.focusedBlockIndex >= 0)
          Positioned(
            left: 16,
            right: 16,
            top: sessionModel.commandEditorPositionY > 0
                ? sessionModel.commandEditorPositionY
                : 100,
            child: CommandSuggestions(
              currentCommand: sessionModel.currentCommand,
              onSuggestionSelected: (suggestion) {
                // Apply the suggestion and refocus
                sessionModel.setCurrentCommand(suggestion);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddBlockButton(BuildContext context, SessionModel model) {
    return InkWell(
      onTap: () {
        model.addEmptyBlock();
        model.setFocusedBlockIndex(model.blocks.length - 1);
        model.setCurrentCommand('');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18),
            SizedBox(width: 8),
            Text("Add block"),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionSummary(BuildContext context, SessionModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, size: 16),
          const SizedBox(width: 8),
          Text(
            'Total workout time: ${_formatDuration(model.totalDurationMinutes)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${mins}m';
    } else {
      return '${mins}m';
    }
  }
}
