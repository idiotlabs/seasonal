import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    // _createRewardedAd();
    // _createRewardedInterstitialAd();
  }

  // 광고 로드
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8206166796422159/1336440199'
            : 'ca-app-pub-8206166796422159/6836935110',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {

          },
        )
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('광고가 준비 되지 않음'),
            content: const Text('광고가 준비 되지 않았습니다.\n그래도 클릭해주셔서 감사합니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        // print('ad onAdShowedFullScreenContent.')
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<void> _openFormUrl() async {
    Uri formUrl = Uri.parse('https://forms.gle/HtbLZEkAHw2zEbhh8');

    if (!await launchUrl(formUrl, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $formUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('세팅'),
        centerTitle: true,
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.menu),
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text("피드백 남기기"),
                onTap: () {
                  _openFormUrl();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.ad_units),
                title: const Text("광고 시청하기"),
                onTap: () {
                  _showInterstitialAd();
                },
              ),
              const Divider(),
              // const ListTile(
              //   leading: Icon(Icons.exit_to_app),
              //   title: Text("Sign Out"),
              // ),
            ],
          ),
        ),
      )
    );
  }
}