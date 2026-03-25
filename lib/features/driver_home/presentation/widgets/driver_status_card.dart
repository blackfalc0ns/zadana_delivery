// import 'package:flutter/material.dart';
// import 'package:zadana_delivery/config/theme/font_manger.dart';
// import 'package:zadana_delivery/config/theme/spacing.dart';
// import 'package:zadana_delivery/config/theme/styles_manger.dart';
// import 'package:zadana_delivery/core/extensions/extensions.dart';

// class DriverStatusCard extends StatelessWidget {
//   const DriverStatusCard({
//     super.key,
//     required this.isOnline,
//     required this.onChanged,
//   });

//   final bool isOnline;
//   final ValueChanged<bool> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     final color = context.colorScheme;
//     final accent = isOnline ? color.primary : color.secondary;

//     return Container(
//       padding: const EdgeInsets.all(Spacing.base),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             accent.withValues(alpha: 0.14),
//             color.surface,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: accent.withValues(alpha: 0.14)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//               color: accent.withValues(alpha: 0.14),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(
//               isOnline
//                   ? Icons.bolt_rounded
//                   : Icons.pause_circle_outline_rounded,
//               color: accent,
//             ),
//           ),
//           const SizedBox(width: Spacing.md),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isOnline ? 'أنت متصل الآن' : 'أنت غير متصل الآن',
//                   style: getBoldStyle(
//                     fontFamily: FontConstant.cairo,
//                     fontSize: FontSize.size15,
//                     color: color.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   isOnline
//                       ? 'سيصلك أي طلب جديد قريب منك فورًا.'
//                       : 'فعّل حالتك الآن لتبدأ استقبال الطلبات.',
//                   style: getRegularStyle(
//                     fontFamily: FontConstant.cairo,
//                     fontSize: FontSize.size12,
//                     color: color.onSurface.withValues(alpha: 0.68),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch.adaptive(
//             value: isOnline,
//             onChanged: onChanged,
//             activeColor: color.primary,
//           ),
//         ],
//       ),
//     );
//   }
// }
