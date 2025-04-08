import 'block.dart';

class TextBlock extends Block {
  final String text;

  TextBlock({
    super.id,
    required this.text,
    String? command,
  }) : super(
          type: BlockType.text,
          command: command ?? text,
          sport: SportType.generic,
        );

  @override
  TextBlock copyWith({
    String? text,
    String? command,
    SportType? sport,
  }) {
    return TextBlock(
      id: id,
      text: text ?? this.text,
      command: command ?? this.command,
    );
  }

  @override
  String toCommandString() => text;

  @override
  List<Object?> get props => [...super.props, text];
}
