import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session_model.dart';

class CommandSuggestions extends StatelessWidget {
  final String currentCommand;
  final Function(String)? onSuggestionSelected;

  const CommandSuggestions({
    Key? key,
    required this.currentCommand,
    this.onSuggestionSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context);

    // Filter suggestions based on current command
    final suggestions = _getSuggestionsForCommand(currentCommand);

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface
            .withOpacity(0.95), // Slightly more opaque
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
        // Add a subtle border
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: Icon(
              suggestion.icon,
              color: Theme.of(context).colorScheme.primary, // Use primary color
            ),
            title: Text(
              suggestion.command,
              style: const TextStyle(
                color: Colors.white, // Ensure white text
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              suggestion.description,
              style: TextStyle(
                color: Colors.grey[300], // Lighter grey for subtitles
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            tileColor: Colors.transparent,
            hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            dense: true,
            onTap: () {
              // Apply the suggestion to the current command
              String newCommand = suggestion.command;

              // Handle parameterized commands
              if (currentCommand.contains('.')) {
                final parts = currentCommand.split('.');
                if (parts.length > 1 &&
                    parts[0] ==
                        '/${suggestion.command.substring(1).split('.')[0]}') {
                  // Keep any parameters after the base command
                  newCommand =
                      '${suggestion.command}.${parts.sublist(1).join('.')}';
                }
              }

              if (onSuggestionSelected != null) {
                onSuggestionSelected!(newCommand);
              } else {
                sessionModel.setCurrentCommand(newCommand);
              }
            },
          );
        },
      ),
    );
  }

  List<CommandSuggestion> _getSuggestionsForCommand(String command) {
    // Remove the leading slash
    final query = command.substring(1).toLowerCase();

    // Filter suggestions
    return _allSuggestions.where((suggestion) {
      return suggestion.command.toLowerCase().contains(query) ||
          suggestion.description.toLowerCase().contains(query);
    }).toList();
  }

  static final List<CommandSuggestion> _allSuggestions = [
    const CommandSuggestion(
      command: '/warmup',
      description: 'Gradually increase intensity',
      icon: Icons.trending_up,
    ),
    const CommandSuggestion(
      command: '/warmup.cycling',
      description: 'Cycling warm up',
      icon: Icons.directions_bike,
    ),
    const CommandSuggestion(
      command: '/warmup.running',
      description: 'Running warm up',
      icon: Icons.directions_run,
    ),
    const CommandSuggestion(
      command: '/interval',
      description: 'High intensity intervals',
      icon: Icons.linear_scale,
    ),
    const CommandSuggestion(
      command: '/interval.cycling',
      description: 'Cycling intervals',
      icon: Icons.directions_bike,
    ),
    const CommandSuggestion(
      command: '/interval.running',
      description: 'Running intervals',
      icon: Icons.directions_run,
    ),
    const CommandSuggestion(
      command: '/circuit',
      description: 'Multiple strength exercises',
      icon: Icons.fitness_center,
    ),
    const CommandSuggestion(
      command: '/circuit.strength',
      description: 'Weight training circuit',
      icon: Icons.fitness_center,
    ),
    const CommandSuggestion(
      command: '/cooldown',
      description: 'Gradually decrease intensity',
      icon: Icons.trending_down,
    ),
    const CommandSuggestion(
      command: '/endurance',
      description: 'Steady state training',
      icon: Icons.watch_later,
    ),
    const CommandSuggestion(
      command: '/tempo',
      description: 'Sustained high effort',
      icon: Icons.speed,
    ),
  ];
}

class CommandSuggestion {
  final String command;
  final String description;
  final IconData icon;

  const CommandSuggestion({
    required this.command,
    required this.description,
    required this.icon,
  });
}
