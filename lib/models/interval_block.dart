import 'workout_block.dart';
import 'block.dart';

class IntervalBlock extends WorkoutBlock {
  final int sets;
  final int workSeconds;
  final int restSeconds;
  final String? cadence; // For cycling
  final String? powerTarget; // For cycling (% of FTP)

  IntervalBlock({
    super.id,
    required super.title,
    required super.durationMinutes,
    required super.intensity,
    super.description = '',
    required super.command,
    required super.sport,
    required this.sets,
    required this.workSeconds,
    required this.restSeconds,
    this.cadence,
    this.powerTarget,
  }) : super(type: BlockType.interval);

  @override
  IntervalBlock copyWith({
    String? title,
    int? durationMinutes,
    String? intensity,
    String? description,
    String? command,
    SportType? sport,
    int? sets,
    int? workSeconds,
    int? restSeconds,
    String? cadence,
    String? powerTarget,
  }) {
    return IntervalBlock(
      id: id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      command: command ?? this.command,
      sport: sport ?? this.sport,
      sets: sets ?? this.sets,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      cadence: cadence ?? this.cadence,
      powerTarget: powerTarget ?? this.powerTarget,
    );
  }

  @override
  String toCommandString() {
    String baseCommand = '/interval';
    if (sport != SportType.generic) {
      baseCommand += '.${sport.name}';
    }
    baseCommand += '.${durationMinutes}min';
    baseCommand += '.${sets}x${workSeconds}s:${restSeconds}s';
    if (intensity.isNotEmpty) {
      baseCommand += '.$intensity';
    }
    if (cadence != null) {
      baseCommand += '.${cadence}rpm';
    }
    return baseCommand;
  }

  @override
  List<Object?> get props =>
      [...super.props, sets, workSeconds, restSeconds, cadence, powerTarget];
}
