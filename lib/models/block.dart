import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum BlockType {
  text,
  warmup,
  interval,
  circuit,
  strength,
  cooldown,
  endurance,
  tempo,
  activeRecovery,
}

enum SportType {
  cycling,
  running,
  swimming,
  strength,
  generic,
}

abstract class Block extends Equatable {
  final String id;
  final BlockType type;
  final String command;
  final SportType sport;

  Block({
    String? id,
    required this.type,
    required this.command,
    required this.sport,
  }) : id = id ?? const Uuid().v4();

  Block copyWith({String? command, SportType? sport});

  String toCommandString();

  Color get color {
    switch (sport) {
      case SportType.cycling:
        return Colors.green;
      case SportType.running:
        return Colors.blue;
      case SportType.swimming:
        return Colors.lightBlue;
      case SportType.strength:
        return Colors.red;
      // case SportType.generic:
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (type) {
      case BlockType.warmup:
        return Icons.local_fire_department;
      case BlockType.interval:
        return Icons.repeat;
      case BlockType.circuit:
        return Icons.loop;
      case BlockType.strength:
        return Icons.fitness_center;
      case BlockType.cooldown:
        return Icons.ac_unit;
      case BlockType.endurance:
        return Icons.directions_run;
      case BlockType.tempo:
        return Icons.speed;
      case BlockType.activeRecovery:
        return Icons.battery_charging_full;
      case BlockType.text:
      default:
        return Icons.text_fields;
    }
  }

  @override
  List<Object?> get props => [id, type, command, sport];
}
