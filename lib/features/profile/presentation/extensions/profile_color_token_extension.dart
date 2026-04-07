import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';

extension ProfileColorTokenExtension on ProfileColorToken {
  Color resolve(ColorScheme colorScheme) {
    return switch (this) {
      ProfileColorToken.primary => colorScheme.primary,
      ProfileColorToken.secondary => colorScheme.secondary,
      ProfileColorToken.tertiary => colorScheme.tertiary,
      ProfileColorToken.error => colorScheme.error,
    };
  }
}
