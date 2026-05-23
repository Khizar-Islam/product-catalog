import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _fade = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fade,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: 5,
          itemBuilder: (_, __) => _GhostCard(opacity: _fade.value),
        );
      },
    );
  }
}

class _GhostCard extends StatelessWidget {
  final double opacity;
  const _GhostCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            _box(48, 48, radius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(14, double.infinity, radius: 7),
                  const SizedBox(height: 8),
                  _box(12, 80, radius: 6),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _box(32, 32, radius: 8),
            const SizedBox(width: 8),
            _box(32, 32, radius: 8),
          ],
        ),
      ),
    );
  }

  Widget _box(double height, double width, {required double radius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppTheme.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}