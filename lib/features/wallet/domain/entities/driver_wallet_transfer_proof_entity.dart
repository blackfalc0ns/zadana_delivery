import 'dart:typed_data';

class DriverWalletTransferProofEntity {
  const DriverWalletTransferProofEntity({
    required this.bytes,
    required this.fileName,
  });

  final Uint8List bytes;
  final String fileName;
}
