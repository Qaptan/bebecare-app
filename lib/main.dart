import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models/baby_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingDone = prefs.getBool('onboarding_done') ?? false;
  runApp(BebeCareApp(onboardingDone: onboardingDone));
}

class BebeCareApp extends StatelessWidget {
  final bool onboardingDone;
  const BebeCareApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BabyProvider(),
      child: MaterialApp(
        title: 'BebeCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F0F13),
          primaryColor: const Color(0xFF7C3AED),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7C3AED),
            secondary: Color(0xFFA78BFA),
            surface: Color(0xFF16161E),
            background: Color(0xFF0F0F13),
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: onboardingDone ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  }
}
