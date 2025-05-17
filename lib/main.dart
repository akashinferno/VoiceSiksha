import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart'; // Import the styles file
import 'package:deaf_dumb_app/widgets/settings.dart';
import 'package:deaf_dumb_app/widgets/practice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ])
        .then((_) {
          runApp(const VoiceSikshaApp());
        })
        .catchError((error) {
          print("Error setting device orientation: $error");
          runApp(const VoiceSikshaApp());
        });
  } catch (e) {
    print("An error occurred: $e");
    runApp(const VoiceSikshaApp());
  }
}

class VoiceSikshaApp extends StatelessWidget {
  const VoiceSikshaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceSiksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use the light green color scheme defined in styles.dart
        primaryColor: AppColors.primaryGreen,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryGreen,
          secondary: AppColors.secondaryGreen,
          background: AppColors.white,
          surface: AppColors.white,
          error: Colors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.black,
          onBackground: AppColors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.headline1,
          displayMedium: AppTextStyles.headline2,
          displaySmall: AppTextStyles.headline3,
          headlineMedium: AppTextStyles.headline4,
          headlineSmall: AppTextStyles.headline5,
          titleLarge: AppTextStyles.headline6,
          titleMedium: AppTextStyles.subtitle1,
          titleSmall: AppTextStyles.subtitle2,
          bodyLarge: AppTextStyles.bodyText1,
          bodyMedium: AppTextStyles.bodyText2,
          labelLarge: AppTextStyles.button,
          bodySmall: AppTextStyles.caption,
          labelSmall: AppTextStyles.overline,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen, // Use primaryGreen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'VoiceSiksha',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const PracticeWidget(),
    const Center(
      child: Text(
        'Learn Section',
        style: TextStyle(fontSize: 24, color: AppColors.black),
      ),
    ),
    const SettingsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VoiceSiksha',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryGreen, // Use primaryGreen
        centerTitle: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryGreen, // Use primaryGreen
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.lightGreen, // Use lightGreen
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.speaker), label: 'Practice'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
