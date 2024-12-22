import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/provider/provider_health_data.dart';
import 'package:vitals/view/history/screen_history.dart';
import 'package:vitals/view/setting/screen_setting.dart';
import 'package:vitals/widgets/animation/animated_health_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        actions: [
          AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<HealthData>(
        stream: context.watch<ProviderHealthData>().healthDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorAnimation();
          }

          if (!snapshot.hasData) {
            return _buildLoadingAnimation();
          }

          final healthData = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger manual refresh
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedHealthCard(
                    title: 'Heart Rate',
                    value: '${healthData.heartRate}',
                    unit: 'BPM',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  AnimatedHealthCard(
                    title: 'Steps',
                    value: '${healthData.steps}',
                    unit: 'steps',
                    icon: Icons.directions_walk,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  // AnimatedHealthCard(
                  //   title: 'Blood Pressure',
                  //   value: '${healthData.bloodPressure.systolic}/${healthData.bloodPressure!.diastolic}',
                  //   unit: 'mmHg',
                  //   icon: Icons.favorite_border,
                  //   color: Colors.blue,
                  // ),
                  const SizedBox(height: 24),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: const Icon(Icons.history),
                      label: const Text('View History'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorAnimation() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1500),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value * 2 * 3.14159,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
