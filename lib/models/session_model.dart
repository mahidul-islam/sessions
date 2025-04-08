import 'package:flutter/foundation.dart';
import '../models/block.dart';
import '../models/text_block.dart';
import '../command_parser.dart';
import 'workout_block.dart';

class SessionModel extends ChangeNotifier {
  final List<Block> _blocks = [
    TextBlock(text: 'Start typing or use / for commands')
  ];
  int _focusedBlockIndex = 0;
  bool _showCommandSuggestions = false;
  String _currentCommand = '';

  List<Block> get blocks => _blocks;
  int get focusedBlockIndex => _focusedBlockIndex;
  bool get showCommandSuggestions => _showCommandSuggestions;
  String get currentCommand => _currentCommand;

  int get totalDurationMinutes {
    int total = 0;
    for (final block in _blocks) {
      if (block is WorkoutBlock) {
        total += block.durationMinutes;
      }
    }
    return total;
  }

  void addBlock(Block block) {
    _blocks.add(block);
    _focusedBlockIndex = _blocks.length - 1;
    notifyListeners();
  }

  void insertBlockAt(int index, Block block) {
    _blocks.insert(index, block);
    _focusedBlockIndex = index;
    notifyListeners();
  }

  void removeBlockAt(int index) {
    if (index >= 0 && index < _blocks.length) {
      _blocks.removeAt(index);
      if (_focusedBlockIndex >= _blocks.length) {
        _focusedBlockIndex = _blocks.length - 1;
      }
      notifyListeners();
    }
  }

  void updateBlockAt(int index, Block block) {
    if (index >= 0 && index < _blocks.length) {
      _blocks[index] = block;
      notifyListeners();
    }
  }

  void moveBlock(int oldIndex, int newIndex) {
    if (oldIndex >= 0 &&
        oldIndex < _blocks.length &&
        newIndex >= 0 &&
        newIndex < _blocks.length) {
      final block = _blocks.removeAt(oldIndex);
      _blocks.insert(newIndex, block);
      _focusedBlockIndex = newIndex;
      notifyListeners();
    }
  }

  void duplicateBlockAt(int index) {
    if (index >= 0 && index < _blocks.length) {
      final block = _blocks[index];
      final newBlock = CommandParser.parseCommand(block.toCommandString());
      _blocks.insert(index + 1, newBlock);
      _focusedBlockIndex = index + 1;
      notifyListeners();
    }
  }

  void convertBlockToCommand(int index) {
    if (index >= 0 && index < _blocks.length) {
      _currentCommand = _blocks[index].toCommandString();
      notifyListeners();
    }
  }

  void convertCommandToBlock() {
    if (_currentCommand.isNotEmpty) {
      final block = CommandParser.parseCommand(_currentCommand);
      if (_focusedBlockIndex >= 0 && _focusedBlockIndex < _blocks.length) {
        _blocks[_focusedBlockIndex] = block;
      } else {
        _blocks.add(block);
        _focusedBlockIndex = _blocks.length - 1;
      }
      _currentCommand = '';
      _showCommandSuggestions = false;
      notifyListeners();
    }
  }

  void setFocusedBlockIndex(int index) {
    _focusedBlockIndex = index;
    notifyListeners();
  }

  void setCurrentCommand(String command) {
    _currentCommand = command;
    _showCommandSuggestions = command.startsWith('/');
    notifyListeners();
  }
}
