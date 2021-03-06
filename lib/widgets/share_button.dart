import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart' as share;
import 'package:minsk8/import.dart';

class ShareButton extends StatelessWidget {
  ShareButton(
    this.item, {
    this.iconSize = kButtonIconSize,
  });

  final ItemModel item;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Share',
      child: Material(
        child: InkWell(
          // borderRadius: BorderRadius.all(kImageBorderRadius),
          child: Container(
            child: Icon(
              Icons.share,
              color: Colors.black.withOpacity(0.8),
              size: iconSize,
            ),
          ),
          onTap: _onTap,
        ),
      ),
    );
  }

  _onTap() {
    // TODO: реализовать ожидание для buildShortLink()
    final fn = () async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://minsk8.page.link',
        link: Uri.parse('https://minsk8.example.com/item?id=${item.id}'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.minsk8',
          minimumVersion: 1,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        // socialMetaTagParameters: SocialMetaTagParameters(
        //   title: 'Example of a Dynamic Link',
        //   description: 'This link works whether app is installed or not!',
        //   // TODO: The URL to an image related to this link. The image should be at least 300x200 px, and less than 300 KB.
        //   // imageUrl:
        // ),
        navigationInfoParameters: NavigationInfoParameters(
          forcedRedirectEnabled: false,
        ),
      );
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      Uri url = shortLink.shortUrl;
      // print('${item.id} $url');
      // TODO: изменить тексты
      share.Share.share(
        'check out my website $url',
        subject: 'Look what I made!',
      );
    };
    fn();
  }
}
