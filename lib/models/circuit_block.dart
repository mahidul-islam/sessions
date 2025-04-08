import 'workout_block.dart';
import 'block.dart';

class CircuitBlock extends WorkoutBlock {
  final int rounds;
  final List<String> exercises;
  final int? workSeconds;
  final int? restSeconds;
  final int? restBetweenRounds;

  CircuitBlock({
    super.id,
    required super.title,
    required super.durationMinutes,
    required super.intensity,
    super.description = '',
    required super.command,
    required super.sport,
    required this.rounds,
    required this.exercises,
    this.workSeconds,
    this.restSeconds,
    this.restBetweenRounds,
  }) : super(type: BlockType.circuit);

  @override
  CircuitBlock copyWith({
    String? title,
    int? durationMinutes,
    String? intensity,
    String? description,
    String? command,
    SportType? sport,
    int? rounds,
    List<String>? exercises,
    int? workSeconds,
    int? restSeconds,
    int? restBetweenRounds,
  }) {
    return CircuitBlock(
      id: id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      command: command ?? this.command,
      sport: sport ?? this.sport,
      rounds: rounds ?? this.rounds,
      exercises: exercises ?? this.exercises,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      restBetweenRounds: restBetweenRounds ?? this.restBetweenRounds,
    );
  }

  @override
  String toCommandString() {
    String baseCommand = '/circuit';
    if (sport != SportType.generic) {
      baseCommand += '.${sport.name}';
    }
    baseCommand += '.${durationMinutes}min';
    baseCommand += '.${rounds}x${exercises.length}';
    if (workSeconds != null && restSeconds != null) {
      baseCommand += '.${workSeconds}s:${restSeconds}s';
    }
    if (intensity.isNotEmpty) {
      baseCommand += '.$intensity';
    }
    return baseCommand;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        rounds,
        exercises,
        workSeconds,
        restSeconds,
        restBetweenRounds
      ];
}
