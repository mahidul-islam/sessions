import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session_model.dart';
import 'block_renderer.dart';
import 'command_input.dart';
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
                  padding: const EdgeInsets.only(top: 16, bottom: 80),
                  itemCount: sessionModel.blocks.length,
                  itemBuilder: (context, index) {
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

        // Command input at the bottom
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CommandInput(),
        ),

        // Command suggestions dropdown
        if (sessionModel.showCommandSuggestions)
          Positioned(
            left: 16,
            right: 16,
            bottom: 56,
            child: CommandSuggestions(
              currentCommand: sessionModel.currentCommand,
            ),
          ),
      ],
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
