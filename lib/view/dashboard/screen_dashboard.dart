import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/provider/provider_health_data.dart';
import 'package:vitals/view/history/screen_history.dart';
import 'package:vitals/view/setting/screen_setting.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Hero(
          tag: 'dashboard_title',
          child: Material(
            color: Colors.transparent,
            child: Text('Health Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        actions: [
          _buildSettingsButton(context),
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
          return _buildDashboardContent(context, healthData);
        },
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: Colors.black),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ).then((value) {
          if (value != null) {
            Provider.of<ProviderHealthData>(context, listen: false).dispose();
          }
        });
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, HealthData healthData) {
    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHealthCard(
                    context: context,
                    title: 'Heart Rate',
                    value: '${healthData.heartRate}',
                    unit: 'BPM',
                    icon: Icons.favorite,
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHealthCard(
                    context: context,
                    title: 'Steps',
                    value: '${healthData.steps}',
                    unit: 'steps',
                    icon: Icons.directions_walk,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(icon, color: Colors.white, size: 24),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    unit,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HistoryScreen()),
      ),
      child: Container(
        width: 200,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'View History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorAnimation() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: value * 2 * 3.14159,
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: value,
                child: const Text('Loading health data...'),
              ),
            ],
          );
        },
      ),
    );
  }
}
