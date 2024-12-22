
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/provider/provider_health_data.dart';

class AnimatedHealthCard extends StatefulWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const AnimatedHealthCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  State<AnimatedHealthCard> createState() => _AnimatedHealthCardState();
}

class _AnimatedHealthCardState extends State<AnimatedHealthCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      _buildAnimatedIcon(),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildAnimatedValue(value),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            widget.icon,
            size: 48,
            color: widget.color.withOpacity(value),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedValue(double animation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: double.parse(widget.value)),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          widget.unit,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

