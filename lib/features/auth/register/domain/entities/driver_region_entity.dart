class DriverRegionEntity {
  const DriverRegionEntity({
    required this.code,
    required this.name,
    this.nameAr = '',
    this.nameEn = '',
    this.isOperational = false,
  });

  final String code;
  final String name;
  final String nameAr;
  final String nameEn;
  final bool isOperational;
}
