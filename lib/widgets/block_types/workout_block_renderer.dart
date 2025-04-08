import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session_model.dart';
import '../../models/workout_block.dart';

class WorkoutBlockRenderer extends StatelessWidget {
  final WorkoutBlock block;

  const WorkoutBlockRenderer({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionModel = Provider.of<SessionModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColorForType(context, block.type.name),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildFields(context),
          const SizedBox(height: 8),
          _buildCommandString(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getIconForType(block.type.name),
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '${_capitalizeFirst(block.type.name)} - ${_capitalizeFirst(block.sport.name)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        if (block.durationMinutes > 0)
          Text(
            '${block.durationMinutes} min',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
      ],
    );
  }

  Widget _buildFields(BuildContext context) {
    // Display the actual properties from the WorkoutBlock
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldRow(context, 'Title', block.title),
        _buildFieldRow(context, 'Duration', '${block.durationMinutes} min'),
        _buildFieldRow(context, 'Intensity', block.intensity),
        if (block.description.isNotEmpty)
          _buildFieldRow(context, 'Description', block.description),
      ],
    );
  }

  Widget _buildFieldRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: _buildEditableField(
              context,
              label.toLowerCase(),
              value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    String paramName,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        onChanged: (newValue) {
          // Update the parameter value in the block
          // In a real app, you'd update the model here
        },
      ),
    );
  }

  Widget _buildCommandString(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        block.toCommandString(),
        style: const TextStyle(
          fontFamily: 'Monospace',
          fontSize: 12,
          color: Colors.white70,
        ),
      ),
    );
  }

  Color _getColorForType(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'warmup':
        return Colors.orange.shade700;
      case 'interval':
        return Colors.red.shade700;
      case 'tempo':
        return Colors.purple.shade700;
      case 'endurance':
        return Colors.blue.shade700;
      case 'cooldown':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'warmup':
        return Icons.trending_up;
      case 'interval':
        return Icons.linear_scale;
      case 'tempo':
        return Icons.speed;
      case 'endurance':
        return Icons.watch_later;
      case 'cooldown':
        return Icons.trending_down;
      default:
        return Icons.fitness_center;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}
