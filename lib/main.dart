import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:seasonal/screens/list_screen.dart';
import 'package:seasonal/screens/tab_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Crashlytics
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Google Admob
  MobileAds.instance.initialize();

  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://b29cf7c2eb564e1184a155a90a43aaa7@o275739.ingest.sentry.io/4504779956486144';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      // home: const ListScreen(),
      home: const TabScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late Future<List> _goodData;
//
//   Future<List> getGoods() async {
//     log('Start getGoods()');
//
//     var token = Constants.apiToken;
//
//     var url = Uri.parse("${Constants.apiBaseUrl}/dev/goods");
//     final response = await http.get(url, headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     });
//
//     return json.decode(response.body);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _goodData = getGoods();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const title = '제철음식';
//
//     // 처음 시작할때 API가 느리면 listview에 아무것도 나오지 않음
//     // - FutureBuilder 사용 추가
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(title),
//           elevation: 1,
//           shadowColor: Theme.of(context).shadowColor,
//         ),
//         body: FutureBuilder(
//             future: _goodData,
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               var goods = snapshot.data ?? [];
//
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                   return const Center(child: CircularProgressIndicator());
//                 default:
//                   return HomeListViewWidget(goods: goods);
//               }
//             }
//         )
//     );
//   }
// }
