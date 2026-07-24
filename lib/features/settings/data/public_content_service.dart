import 'package:dio/dio.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/services/token_interceptor.dart';

class PlatformContact {
  const PlatformContact({
    this.supportEmail,
    this.supportPhone,
    this.whatsAppUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.tikTokUrl,
    this.snapchatUrl,
    this.facebookUrl,
    this.youTubeUrl,
    this.linkedInUrl,
  });

  factory PlatformContact.fromJson(Map<String, dynamic> json) =>
      PlatformContact(
        supportEmail: json['supportEmail'] as String?,
        supportPhone: json['supportPhone'] as String?,
        whatsAppUrl: json['whatsAppUrl'] as String?,
        instagramUrl: json['instagramUrl'] as String?,
        twitterUrl: json['twitterUrl'] as String?,
        tikTokUrl: json['tikTokUrl'] as String?,
        snapchatUrl: json['snapchatUrl'] as String?,
        facebookUrl: json['facebookUrl'] as String?,
        youTubeUrl: json['youTubeUrl'] as String?,
        linkedInUrl: json['linkedInUrl'] as String?,
      );

  final String? supportEmail,
      supportPhone,
      whatsAppUrl,
      instagramUrl,
      twitterUrl,
      tikTokUrl,
      snapchatUrl,
      facebookUrl,
      youTubeUrl,
      linkedInUrl;

  List<(String, String)> get socialLinks => [
    ('instagram', instagramUrl ?? ''),
    ('twitter', twitterUrl ?? ''),
    ('tiktok', tikTokUrl ?? ''),
    ('snapchat', snapchatUrl ?? ''),
    ('facebook', facebookUrl ?? ''),
    ('youtube', youTubeUrl ?? ''),
    ('linkedin', linkedInUrl ?? ''),
  ].where((item) => _validUrl(item.$2)).toList();

  static bool _validUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'https' || uri.scheme == 'http');
  }
}

class LegalDocument {
  const LegalDocument({
    required this.contentAr,
    required this.contentEn,
    required this.version,
    this.effectiveAtUtc,
  });
  factory LegalDocument.fromJson(Map<String, dynamic> json) => LegalDocument(
    contentAr: json['contentAr'] as String? ?? '',
    contentEn: json['contentEn'] as String? ?? '',
    version: json['version'] as String? ?? '',
    effectiveAtUtc: DateTime.tryParse(json['effectiveAtUtc'] as String? ?? ''),
  );
  final String contentAr, contentEn, version;
  final DateTime? effectiveAtUtc;
  String contentFor(bool isArabic) {
    final primary = (isArabic ? contentAr : contentEn).trim();
    return primary.isNotEmpty
        ? primary
        : (isArabic ? contentEn : contentAr).trim();
  }
}

/// Public CMS data. A short in-memory cache avoids repeated requests while
/// keeping admin changes visible on the next app session.
class PublicContentService {
  PublicContentService._();
  static final instance = PublicContentService._();
  PlatformContact? _contact;
  final Map<String, LegalDocument> _legal = {};

  Future<PlatformContact> getContact() async {
    if (_contact != null) return _contact!;
    final response = await getIt<Dio>().get<dynamic>(
      '/public/platform-contact',
      options: Options(extra: {TokenInterceptor.skipAuthKey: true}),
    );
    return _contact = PlatformContact.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<LegalDocument> getLegal(String type) async {
    if (_legal[type] != null) return _legal[type]!;
    final response = await getIt<Dio>().get<dynamic>(
      '/public/legal/$type',
      options: Options(extra: {TokenInterceptor.skipAuthKey: true}),
    );
    return _legal[type] = LegalDocument.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
