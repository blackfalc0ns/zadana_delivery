import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/domain/repo/driver_home_repository.dart';

@injectable
class WatchDriverHomeUseCase {
  const WatchDriverHomeUseCase(this._repository);

  final DriverHomeRepository _repository;

  Stream<DriverHomeEntity> call() {
    return _repository.watchHome();
  }
}
