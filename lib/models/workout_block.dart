import 'block.dart';

class WorkoutBlock extends Block {
  final String title;
  final int durationMinutes;
  final String intensity;
  final String description;

  WorkoutBlock({
    super.id,
    required super.type,
    required this.title,
    required this.durationMinutes,
    required this.intensity,
    this.description = '',
    required super.command,
    required super.sport,
  });

  @override
  WorkoutBlock copyWith({
    String? title,
    int? durationMinutes,
    String? intensity,
    String? description,
    String? command,
    SportType? sport,
  }) {
    return WorkoutBlock(
      id: id,
      type: type,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      command: command ?? this.command,
      sport: sport ?? this.sport,
    );
  }

  @override
  String toCommandString() {
    String baseCommand = '/${_getTypeString()}';
    if (sport != SportType.generic) {
      baseCommand += '.${sport.name}';
    }
    baseCommand += '.${durationMinutes}min';
    if (intensity.isNotEmpty) {
      baseCommand += '.$intensity';
    }
    return baseCommand;
  }

  String _getTypeString() {
    switch (type) {
      case BlockType.warmup:
        return 'warmup';
      case BlockType.interval:
        return 'interval';
      case BlockType.circuit:
        return 'circuit';
      case BlockType.strength:
        return 'strength';
      case BlockType.cooldown:
        return 'cooldown';
      case BlockType.endurance:
        return 'endurance';
      case BlockType.tempo:
        return 'tempo';
      case BlockType.activeRecovery:
        return 'activerecovery';
      default:
        return 'text';
    }
  }

  @override
  List<Object?> get props =>
      [...super.props, title, durationMinutes, intensity, description];
}
