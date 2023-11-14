import 'package:flutter/material.dart';
import 'package:rainbow/rainbow/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const url1 = 'HTTPS://GITHUB.COM/GRADPROJECTT';
    const url2 = 'https://github.com/YBIGTA/CatchTone/blob/master/README.md';
    return Scaffold(
      backgroundColor: Color(0xffd9d9d9),
      appBar: AppBar(
        backgroundColor: Color(0xffd9d9d9),
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/splash2.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse(url1));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.link_rounded),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      url1,
                      style: kTs.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse(url2));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.link_rounded),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        url2,
                        style: kTs.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
