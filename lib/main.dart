import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_options.dart';
import 'package:projrect_annam/auth/startup_view.dart';
import 'package:projrect_annam/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
    [ 
      DeviceOrientation.portraitUp,
    ],
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  runApp(
    ProviderScope(
      child: MyApp(
        defaultHome: StartupView(
          initScreen: initScreen,
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget with CustomThemeDataMixin {
  final Widget defaultHome;

  MyApp({super.key, required this.defaultHome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeProvider).keys.first;
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      title: 'Annam',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: defaultHome,
    );
  }
}
