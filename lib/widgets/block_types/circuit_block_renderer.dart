import 'package:flutter/material.dart';
import '../../models/circuit_block.dart';

class CircuitBlockRenderer extends StatelessWidget {
  final CircuitBlock block;

  const CircuitBlockRenderer({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildCircuitDetails(context),
          const SizedBox(height: 16),
          _buildExercisesList(context),
          const SizedBox(height: 8),
          _buildCommandString(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.fitness_center,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Circuit - ${block.rounds} rounds',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
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

  Widget _buildCircuitDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Rounds', '${block.rounds}x', Icons.repeat),
        _buildDetailRow('Work', '${block.workSeconds ?? 0}s', Icons.flash_on),
        _buildDetailRow(
            'Rest', '${block.restSeconds ?? 0}s', Icons.hourglass_bottom),
        _buildDetailRow('Rest Between Rounds',
            '${block.restBetweenRounds ?? 0}s', Icons.hourglass_empty),
      ],
    );
  }

  Widget _buildExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercises:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        ...block.exercises.asMap().entries.map((entry) {
          final index = entry.key;
          final exercise = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white70,
                    size: 18,
                  ),
                  onPressed: () {
                    // Handle exercise edit
                  },
                ),
              ],
            ),
          );
        }).toList(),
        // Add Exercise Button
        TextButton.icon(
          icon: const Icon(Icons.add, color: Colors.white70),
          label: const Text(
            'Add Exercise',
            style: TextStyle(color: Colors.white70),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            // Handle adding a new exercise
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Icon(
              icon,
              size: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
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
}
