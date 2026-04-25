import 'package:flutter/material.dart';

import 'base_error_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return BaseErrorWidget(
      title: title,
      description: description,
      icon: icon,
      primaryColor: Theme.of(context).colorScheme.primary,
    );
  }
}
