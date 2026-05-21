import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcePickerSheet {
  const ImageSourcePickerSheet._();

  static Future<ImageSource?> show(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String text(String ar, String en) => isArabic ? ar : en;

    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(sheetContext).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(text('الكاميرا', 'Camera')),
                  onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(text('المعرض', 'Gallery')),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
