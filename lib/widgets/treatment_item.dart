import 'package:flutter/material.dart';

class TreatmentItem extends StatelessWidget {
  final String title;
  final String description;
  final TreatmentType type;
  final TreatmentUrgency urgency;
  final VoidCallback? onTap;
  final bool isCompleted;

  const TreatmentItem({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    required this.urgency,
    this.onTap,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeConfig = _getTreatmentTypeConfig(type);
    final urgencyConfig = _getUrgencyConfig(urgency);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.grey[50] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? Colors.grey[300]!
                    : urgencyConfig.color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: isCompleted ? [] : [
                BoxShadow(
                  color: urgencyConfig.color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.grey[200]
                            : typeConfig.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_circle : typeConfig.icon,
                        color: isCompleted ? Colors.grey : typeConfig.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isCompleted ? Colors.grey : Colors.black87,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            typeConfig.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted ? Colors.grey : typeConfig.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Urgency indicator
                    if (!isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: urgencyConfig.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: urgencyConfig.color.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              urgencyConfig.icon,
                              size: 12,
                              color: urgencyConfig.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              urgencyConfig.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: urgencyConfig.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted ? Colors.grey : Colors.grey[600],
                    height: 1.4,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                if (!isCompleted) ...[
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Mark as completed
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Complete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Postpone treatment
                          },
                          icon: const Icon(Icons.schedule, size: 16),
                          label: const Text('Later'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _TreatmentTypeConfig _getTreatmentTypeConfig(TreatmentType type) {
    switch (type) {
      case TreatmentType.watering:
        return _TreatmentTypeConfig(
          icon: Icons.water_drop,
          color: Colors.blue,
          label: 'Watering',
        );
      case TreatmentType.fertilizing:
        return _TreatmentTypeConfig(
          icon: Icons.scatter_plot,
          color: Colors.green,
          label: 'Fertilizing',
        );
      case TreatmentType.pesticide:
        return _TreatmentTypeConfig(
          icon: Icons.bug_report,
          color: Colors.red,
          label: 'Pest Control',
        );
      case TreatmentType.pruning:
        return _TreatmentTypeConfig(
          icon: Icons.content_cut,
          color: Colors.brown,
          label: 'Pruning',
        );
      case TreatmentType.harvesting:
        return _TreatmentTypeConfig(
          icon: Icons.agriculture,
          color: Colors.orange,
          label: 'Harvesting',
        );
      case TreatmentType.soilCare:
        return _TreatmentTypeConfig(
          icon: Icons.landscape,
          color: Colors.amber,
          label: 'Soil Care',
        );
      case TreatmentType.general:
        return _TreatmentTypeConfig(
          icon: Icons.eco,
          color: Colors.green,
          label: 'General Care',
        );
    }
  }

  _UrgencyConfig _getUrgencyConfig(TreatmentUrgency urgency) {
    switch (urgency) {
      case TreatmentUrgency.low:
        return _UrgencyConfig(
          icon: Icons.info,
          color: Colors.green,
          label: 'Low',
        );
      case TreatmentUrgency.medium:
        return _UrgencyConfig(
          icon: Icons.warning_amber,
          color: Colors.orange,
          label: 'Medium',
        );
      case TreatmentUrgency.high:
        return _UrgencyConfig(
          icon: Icons.priority_high,
          color: Colors.red,
          label: 'High',
        );
      case TreatmentUrgency.critical:
        return _UrgencyConfig(
          icon: Icons.error,
          color: Colors.red[700]!,
          label: 'Critical',
        );
    }
  }
}

// Enums and helper classes
enum TreatmentType {
  watering,
  fertilizing,
  pesticide,
  pruning,
  harvesting,
  soilCare,
  general,
}

enum TreatmentUrgency {
  low,
  medium,
  high,
  critical,
}

class _TreatmentTypeConfig {
  final IconData icon;
  final Color color;
  final String label;

  _TreatmentTypeConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
}

class _UrgencyConfig {
  final IconData icon;
  final Color color;
  final String label;

  _UrgencyConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
}
