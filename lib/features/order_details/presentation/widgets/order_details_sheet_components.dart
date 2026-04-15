import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';

class SheetContainer extends StatelessWidget {
  const SheetContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 46,
        height: 5,
        decoration: BoxDecoration(
          color: scheme.outlineVariant.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class SheetConfirmButton extends StatelessWidget {
  const SheetConfirmButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SheetNote extends StatelessWidget {
  const SheetNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          note,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            color: scheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
