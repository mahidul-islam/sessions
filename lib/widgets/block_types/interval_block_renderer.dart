import 'package:flutter/material.dart';
import '../../models/interval_block.dart';

class IntervalBlockRenderer extends StatelessWidget {
  final IntervalBlock block;

  const IntervalBlockRenderer({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildIntervalDetails(context),
          const SizedBox(height: 8),
          _buildCommandString(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final sportIcon = block.sport.name == 'cycling'
        ? Icons.directions_bike
        : block.sport.name == 'running'
            ? Icons.directions_run
            : Icons.fitness_center;

    return Row(
      children: [
        const Icon(
          Icons.linear_scale,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 4),
        Icon(
          sportIcon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '${block.sets}x ${block.workSeconds}/${block.restSeconds} Intervals',
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

  Widget _buildIntervalDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Sets', '${block.sets}x', Icons.repeat),
        _buildDetailRow('Work', '${block.workSeconds}s', Icons.flash_on),
        _buildDetailRow(
            'Rest', '${block.restSeconds}s', Icons.hourglass_bottom),
        _buildDetailRow('Intensity', block.intensity, Icons.speed),

        // Sport-specific properties
        if (block.cadence != null && block.cadence!.isNotEmpty)
          _buildDetailRow('Cadence', '${block.cadence}', Icons.rotate_right),

        if (block.powerTarget != null && block.powerTarget!.isNotEmpty)
          _buildDetailRow('Power Target', '${block.powerTarget}', Icons.bolt),
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
            width: 100,
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
