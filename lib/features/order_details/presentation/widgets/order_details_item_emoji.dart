String orderDetailsItemEmoji(String name) {
  if (name.contains('طماطم')) return '🍅';
  if (name.contains('خيار')) return '🥒';
  if (name.contains('بطاطس')) return '🥔';
  if (name.contains('بصل')) return '🧅';
  if (name.contains('ثوم')) return '🧄';
  if (name.contains('جزر')) return '🥕';
  if (name.contains('فلفل')) return '🌶️';
  if (name.contains('باذنجان')) return '🍆';
  if (name.contains('كوسة')) return '🥬';
  if (name.contains('خس')) return '🥬';
  if (name.contains('جرجير')) return '🥗';
  if (name.contains('ملوخية')) return '🥬';
  if (name.contains('سبانخ')) return '🥬';
  if (name.contains('كزبرة')) return '🌿';
  if (name.contains('نعناع')) return '🌿';
  if (name.contains('ليمون')) return '🍋';
  if (name.contains('تفاح')) return '🍎';
  if (name.contains('موز')) return '🍌';
  return '🥦';
}
