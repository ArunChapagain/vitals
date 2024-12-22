import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/provider/provider_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health History'),
      ),
      body: FutureBuilder<List<HealthData>>(
        future: context.read<ProviderHistory>().getHealthHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading history'));
          }
          
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final records = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(record.timestamp),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric(
                            icon: Icons.favorite,
                            value: '${record.heartRate}',
                            unit: 'BPM',
                            color: Colors.red,
                          ),
                          _buildMetric(
                            icon: Icons.directions_walk,
                            value: '${record.steps}',
                            unit: 'steps',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
