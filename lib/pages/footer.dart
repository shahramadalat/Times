import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:times/pages/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('0751 126 2122', style: TextStyle(color: Colors.white70)),
            Text(
              'بۆ پشتگیریکردنمان لەڕێگەی فاستپەی',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            IconButton(
              color: Colors.white54,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '07512319423')).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blueGrey[700],
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(text: 'کۆپی کرا', size: 12),
                          SizedBox(height: 20),
                          Icon(Icons.check, color: Colors.lightGreen),
                        ],
                      ),
                    ),
                  );
                });
              },
              icon: Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () async {
            const url = 'https://shahramadalat.pages.dev/';
            try {
              if (!await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch $url');
              }
            } catch (e) {
              debugPrint('Could not launch url: $e');
            }
          },
          child: Text(
            'Shahram Adalat',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
