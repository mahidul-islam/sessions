import 'models/block.dart';
import 'models/text_block.dart';
import 'models/workout_block.dart';
import 'models/interval_block.dart';
import 'models/circuit_block.dart';

class CommandParser {
  static Block parseCommand(String command) {
    if (command.startsWith('/')) {
      final parts = command.substring(1).split('.');
      final blockType = _parseBlockType(parts[0]);

      // Default values
      SportType sport = SportType.generic;
      int durationMinutes = 10;
      String intensity = '';

      // Parse sport if provided
      if (parts.length > 1 && _isSportType(parts[1])) {
        sport = _parseSportType(parts[1]);
      }

      // Parse duration if provided
      for (final part in parts) {
        if (part.endsWith('min')) {
          try {
            durationMinutes = int.parse(part.replaceAll('min', ''));
          } catch (e) {
            // Use default if parsing fails
          }
        }

        if (part.contains('%')) {
          intensity = part;
        }
      }

      switch (blockType) {
        case BlockType.interval:
          int sets = 5;
          int workSeconds = 60;
          int restSeconds = 30;

          // Parse interval specifics
          for (final part in parts) {
            if (part.contains('x') && part.contains('s:')) {
              final setParts = part.split('x');
              if (setParts.length == 2) {
                try {
                  sets = int.parse(setParts[0]);

                  final timeParts = setParts[1].split('s:');
                  if (timeParts.length == 2) {
                    workSeconds = int.parse(timeParts[0]);
                    restSeconds = int.parse(timeParts[1].replaceAll('s', ''));
                  }
                } catch (e) {
                  // Use defaults if parsing fails
                }
              }
            }
          }

          String? cadence;
          for (final part in parts) {
            if (part.endsWith('rpm')) {
              cadence = part;
            }
          }

          return IntervalBlock(
            title: '${sets}x ${workSeconds}s/${restSeconds}s Intervals',
            durationMinutes: durationMinutes,
            intensity: intensity,
            command: command,
            sport: sport,
            sets: sets,
            workSeconds: workSeconds,
            restSeconds: restSeconds,
            cadence: cadence,
          );

        case BlockType.circuit:
          int rounds = 3;
          int exercises = 5;

          // Parse circuit specifics
          for (final part in parts) {
            if (part.contains('x')) {
              final setParts = part.split('x');
              if (setParts.length == 2) {
                try {
                  rounds = int.parse(setParts[0]);
                  exercises = int.parse(setParts[1]);
                } catch (e) {
                  // Use defaults if parsing fails
                }
              }
            }
          }

          return CircuitBlock(
            title: '$rounds Round Circuit',
            durationMinutes: durationMinutes,
            intensity: intensity,
            command: command,
            sport: sport,
            rounds: rounds,
            exercises: List.generate(exercises, (i) => 'Exercise ${i + 1}'),
          );

        default:
          return WorkoutBlock(
            type: blockType,
            title: _blockTypeToTitle(blockType),
            durationMinutes: durationMinutes,
            intensity: intensity,
            command: command,
            sport: sport,
          );
      }
    } else {
      // Default to text block
      return TextBlock(text: command);
    }
  }

  static BlockType _parseBlockType(String type) {
    switch (type.toLowerCase()) {
      case 'warmup':
        return BlockType.warmup;
      case 'interval':
        return BlockType.interval;
      case 'circuit':
        return BlockType.circuit;
      case 'strength':
        return BlockType.strength;
      case 'cooldown':
        return BlockType.cooldown;
      case 'endurance':
        return BlockType.endurance;
      case 'tempo':
        return BlockType.tempo;
      case 'activerecovery':
        return BlockType.activeRecovery;
      default:
        return BlockType.text;
    }
  }

  static bool _isSportType(String sport) {
    final validSports = ['cycling', 'running', 'swimming', 'strength'];
    return validSports.contains(sport.toLowerCase());
  }

  static SportType _parseSportType(String sport) {
    switch (sport.toLowerCase()) {
      case 'cycling':
        return SportType.cycling;
      case 'running':
        return SportType.running;
      case 'swimming':
        return SportType.swimming;
      case 'strength':
        return SportType.strength;
      default:
        return SportType.generic;
    }
  }

  static String _blockTypeToTitle(BlockType type) {
    switch (type) {
      case BlockType.warmup:
        return 'Warm Up';
      case BlockType.interval:
        return 'Interval Training';
      case BlockType.circuit:
        return 'Circuit Training';
      case BlockType.strength:
        return 'Strength Training';
      case BlockType.cooldown:
        return 'Cool Down';
      case BlockType.endurance:
        return 'Endurance';
      case BlockType.tempo:
        return 'Tempo';
      case BlockType.activeRecovery:
        return 'Active Recovery';
      case BlockType.text:
        return 'Note';
    }
  }
}
