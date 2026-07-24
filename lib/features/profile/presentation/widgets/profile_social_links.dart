import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/features/settings/data/public_content_service.dart';

class ProfileSocialLinks extends StatelessWidget {
  const ProfileSocialLinks({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<PlatformContact>(
    future: PublicContentService.instance.getContact(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return SkeletonStateWidget(
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }

      final links = snapshot.data?.socialLinks ?? const <(String, String)>[];
      if (links.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'تابعنا'
                : 'Follow us',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: links
                .map(
                  (link) => Expanded(
                    child: IconButton(
                      tooltip: link.$1,
                      onPressed: () => _open(link.$2),
                      color:
                          _colors[link.$1] ??
                          Theme.of(context).colorScheme.primary,
                      icon: FaIcon(
                        _icons[link.$1] ?? FontAwesomeIcons.link,
                        size: 26,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    },
  );

  static final _icons = <String, FaIconData>{
    'instagram': FontAwesomeIcons.instagram,
    'twitter': FontAwesomeIcons.xTwitter,
    'tiktok': FontAwesomeIcons.tiktok,
    'snapchat': FontAwesomeIcons.snapchat,
    'facebook': FontAwesomeIcons.facebookF,
    'youtube': FontAwesomeIcons.youtube,
    'linkedin': FontAwesomeIcons.linkedinIn,
  };

  static const _colors = <String, Color>{
    'instagram': Color(0xffE4405F),
    'twitter': Color(0xff000000),
    'tiktok': Color(0xff000000),
    'snapchat': Color(0xffFFFC00),
    'facebook': Color(0xff1877F2),
    'youtube': Color(0xffFF0000),
    'linkedin': Color(0xff0A66C2),
  };

  static Future<void> _open(String raw) async {
    final uri = Uri.tryParse(raw);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
