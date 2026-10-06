import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProgressStepper extends StatelessWidget {
  final int activeStep; // 0..3
  final List<String?>? timeline;

  ProgressStepper({
    super.key,
    int? activeStep,
    String? status,
    this.timeline,
  }) : activeStep = activeStep ?? _getStepFromStatus(status);

  static int _getStepFromStatus(String? status) {
    if (status == null) return 0;
    final s = status.toLowerCase();
    if (s.contains('terima')) return 0;
    if (s.contains('pilah')) return 1;
    if (s.contains('cuci')) return 2;
    if (s.contains('siap') || s.contains('ambil') || s.contains('selesai')) return 3;
    return 0;
  }

  static const List<Map<String, dynamic>> _steps = [
    {'icon': Icons.assignment_outlined, 'label': 'Di Terima'},
    {'icon': Icons.layers_outlined, 'label': 'Di Pilah'},
    {'icon': Icons.local_laundry_service_outlined, 'label': 'Di Cuci'},
    {'icon': Icons.inventory_2_outlined, 'label': 'Siap Ambil'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSteps = _steps.length;
          final double stepWidth = constraints.maxWidth / totalSteps;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Background track line
              Positioned(
                top: 20,
                left: stepWidth / 2,
                right: stepWidth / 2,
                child: Container(
                  height: 3,
                  color: Colors.grey.shade200,
                ),
              ),

              // Active fill line
              Positioned(
                top: 20,
                left: stepWidth / 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 3,
                  width: (activeStep / (totalSteps - 1)) *
                      (constraints.maxWidth - stepWidth),
                  color: AppColors.primary,
                ),
              ),

              // Stepper nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final step = _steps[index];
                  final bool isDone = index <= activeStep;
                  final bool isCurrent = index == activeStep;

                  // Date extracted if available
                  String? stepDate;
                  if (timeline != null && index < timeline!.length && timeline![index] != null) {
                    final parts = timeline![index]!.split('\n');
                    if (parts.length > 1) {
                      stepDate = parts[1];
                    }
                  }

                  return SizedBox(
                    width: stepWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circle Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? AppColors.primary : Colors.white,
                            border: Border.all(
                              color: isDone ? AppColors.primary : Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 18,
                            color: isDone ? Colors.white : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Step Label
                        Text(
                          step['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCurrent
                                ? AppColors.primary
                                : isDone
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                          ),
                        ),

                        // Date if present
                        if (stepDate != null && stepDate.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              stepDate,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
