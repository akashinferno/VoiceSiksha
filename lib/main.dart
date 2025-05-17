// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart'; // Import the styles file
import 'package:deaf_dumb_app/widgets/settings.dart'; // Import the settings file
import 'package:deaf_dumb_app/widgets/practice.dart'; // Import the practice file

void main() {
  // Ensure that the Flutter framework is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientations (portrait only).
  try {
    SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ])
        .then((_) {
          runApp(
            const VoiceSikshaApp(),
          ); // Run the app after setting orientations.
        })
        .catchError((error) {
          print("Error setting device orientation: $error");
          runApp(const VoiceSikshaApp()); // Run the app anyway
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
        // Define the color scheme using the purple palette from styles.dart
        colorScheme: ColorScheme(
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryPurple,
          surface: AppColors.white,
          background: AppColors.white,
          error: Colors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.black,
          onBackground: AppColors.black,
          onError: AppColors.white,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        // Use the text styles from styles.dart
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
      backgroundColor: AppColors.primaryPurple,
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
  // Changed to StatefulWidget
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState(); // Added createState
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Keep track of the selected index.

  // Create a list of widgets for the different sections.
  final List<Widget> _widgetOptions = <Widget>[
    const PracticeWidget(), // Use the PracticeWidget here.
    const Center(
      child: Text(
        'Learn Section',
        style: TextStyle(fontSize: 24, color: AppColors.black),
      ),
    ),
    const SettingsWidget(), // Use the SettingsWidget here.
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
        backgroundColor: AppColors.primaryPurple,
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex), //show selected widget
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Custom bottom navigation bar widget.
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
      backgroundColor: AppColors.primaryPurple,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.lightGrey,
      currentIndex: selectedIndex, // Use the selectedIndex.
      onTap: onItemTapped, // Use the onItemTapped callback.
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.speaker), label: 'Practice'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
