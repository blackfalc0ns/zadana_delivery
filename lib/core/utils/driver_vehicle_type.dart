class DriverVehicleType {
  const DriverVehicleType._();

  static const car = 'Car';
  static const motorcycle = 'Motorcycle';
  static const scooter = 'Scooter';
  static const van = 'Van';
  static const bicycle = 'Bicycle';
  static const truck = 'Truck';

  static const values = <String>[car, motorcycle, scooter, van, bicycle, truck];

  static String normalize(String? rawValue) {
    final value = (rawValue ?? '').trim();
    if (value.isEmpty) return car;

    return switch (value.toLowerCase()) {
      'car' => car,
      'bike' || 'motorbike' || 'motorcycle' => motorcycle,
      'scooter' => scooter,
      'van' => van,
      'bicycle' || 'cycle' => bicycle,
      'truck' => truck,
      _ => _matchKnownValue(value) ?? car,
    };
  }

  static bool usesTwoWheels(String value) {
    return switch (normalize(value)) {
      motorcycle || scooter || bicycle => true,
      _ => false,
    };
  }

  static String? _matchKnownValue(String value) {
    for (final knownValue in values) {
      if (knownValue.toLowerCase() == value.toLowerCase()) {
        return knownValue;
      }
    }
    return value.isEmpty ? null : value;
  }
}
