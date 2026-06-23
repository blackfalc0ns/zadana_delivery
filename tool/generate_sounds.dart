// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

/// Generates simple WAV tone files for notification sound previews.
/// Run with: dart run tool/generate_sounds.dart
void main() {
  const sampleRate = 44100;
  const outputDir = 'assets/sounds';

  final dir = Directory(outputDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // Each sound: (filename, frequency Hz, duration ms, style)
  final sounds = <(String, double, int, String)>[
    ('classic', 880.0, 600, 'single'),   // A5 - clean single tone
    ('chime', 1318.5, 800, 'chime'),     // E6 - two-tone chime
    ('soft', 523.25, 700, 'fade'),       // C5 - soft fade
    ('urgent', 1046.5, 500, 'rapid'),    // C6 - rapid double beep
  ];

  for (final (name, freq, durationMs, style) in sounds) {
    final samples = _generateTone(freq, durationMs, sampleRate, style);
    final wavBytes = _encodeWav(samples, sampleRate);
    final file = File('$outputDir/$name.mp3'); // Actually WAV but named .mp3 for compatibility
    file.writeAsBytesSync(wavBytes);
    print('Generated: $outputDir/$name.mp3 (${wavBytes.length} bytes)');
  }

  print('\nDone! Sound files created in $outputDir/');
}

List<int> _generateTone(
  double frequency,
  int durationMs,
  int sampleRate,
  String style,
) {
  final numSamples = (sampleRate * durationMs / 1000).round();
  final samples = List<int>.filled(numSamples, 0);
  const amplitude = 24000; // ~73% of max int16

  switch (style) {
    case 'single':
      for (var i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        final envelope = _fadeEnvelope(i, numSamples, sampleRate);
        samples[i] = (amplitude * envelope * sin(2 * pi * frequency * t)).round();
      }
    case 'chime':
      final half = numSamples ~/ 2;
      final freq2 = frequency * 1.5; // Perfect fifth up
      for (var i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        final f = i < half ? frequency : freq2;
        final localI = i < half ? i : i - half;
        final localLen = i < half ? half : numSamples - half;
        final envelope = _fadeEnvelope(localI, localLen, sampleRate);
        samples[i] = (amplitude * envelope * sin(2 * pi * f * t)).round();
      }
    case 'fade':
      for (var i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        // Slow fade out
        final envelope = (1.0 - i / numSamples) * _fadeEnvelope(i, numSamples, sampleRate);
        samples[i] = (amplitude * 0.7 * envelope * sin(2 * pi * frequency * t)).round();
      }
    case 'rapid':
      // Two short beeps
      final beepLen = numSamples ~/ 3;
      final gapStart = beepLen;
      final secondStart = beepLen + (numSamples ~/ 6);
      for (var i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        double envelope = 0;
        if (i < beepLen) {
          envelope = _fadeEnvelope(i, beepLen, sampleRate);
        } else if (i >= secondStart && i < secondStart + beepLen) {
          envelope = _fadeEnvelope(i - secondStart, beepLen, sampleRate);
        }
        samples[i] = (amplitude * envelope * sin(2 * pi * frequency * t)).round();
      }
    default:
      for (var i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        samples[i] = (amplitude * sin(2 * pi * frequency * t)).round();
      }
  }

  return samples;
}

double _fadeEnvelope(int sampleIndex, int totalSamples, int sampleRate) {
  // 10ms attack, 50ms release
  const attackSamples = 441; // ~10ms at 44100
  const releaseSamples = 2205; // ~50ms at 44100
  final releaseStart = totalSamples - releaseSamples;

  if (sampleIndex < attackSamples) {
    return sampleIndex / attackSamples;
  }
  if (sampleIndex > releaseStart) {
    return (totalSamples - sampleIndex) / releaseSamples;
  }
  return 1.0;
}

Uint8List _encodeWav(List<int> samples, int sampleRate) {
  final numChannels = 1;
  final bitsPerSample = 16;
  final byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
  final blockAlign = numChannels * bitsPerSample ~/ 8;
  final dataSize = samples.length * blockAlign;
  final fileSize = 36 + dataSize;

  final buffer = ByteData(44 + dataSize);
  var offset = 0;

  // RIFF header
  buffer.setUint8(offset++, 0x52); // R
  buffer.setUint8(offset++, 0x49); // I
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint32(offset, fileSize, Endian.little);
  offset += 4;
  buffer.setUint8(offset++, 0x57); // W
  buffer.setUint8(offset++, 0x41); // A
  buffer.setUint8(offset++, 0x56); // V
  buffer.setUint8(offset++, 0x45); // E

  // fmt chunk
  buffer.setUint8(offset++, 0x66); // f
  buffer.setUint8(offset++, 0x6D); // m
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x20); // (space)
  buffer.setUint32(offset, 16, Endian.little); // chunk size
  offset += 4;
  buffer.setUint16(offset, 1, Endian.little); // PCM format
  offset += 2;
  buffer.setUint16(offset, numChannels, Endian.little);
  offset += 2;
  buffer.setUint32(offset, sampleRate, Endian.little);
  offset += 4;
  buffer.setUint32(offset, byteRate, Endian.little);
  offset += 4;
  buffer.setUint16(offset, blockAlign, Endian.little);
  offset += 2;
  buffer.setUint16(offset, bitsPerSample, Endian.little);
  offset += 2;

  // data chunk
  buffer.setUint8(offset++, 0x64); // d
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint32(offset, dataSize, Endian.little);
  offset += 4;

  // PCM samples
  for (final sample in samples) {
    final clamped = sample.clamp(-32768, 32767);
    buffer.setInt16(offset, clamped, Endian.little);
    offset += 2;
  }

  return buffer.buffer.asUint8List();
}
