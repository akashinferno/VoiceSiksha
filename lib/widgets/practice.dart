import 'package:flutter/material.dart';
import 'package:deaf_dumb_app/styles.dart'; // Import the styles file

class PracticeWidget extends StatefulWidget {
  const PracticeWidget({super.key});

  @override
  _PracticeWidgetState createState() => _PracticeWidgetState();
}

class _PracticeWidgetState extends State<PracticeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Use AppColors.white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeTransition(
              // Use FadeTransition
              opacity: _fadeAnimation,
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black, // Use AppColors.black
                  fontFamily:
                      'Pacifico', // Use the font family name you declared in pubspec.yaml
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Modules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black, // Use AppColors.black
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HindiLettersPronunciation(),
                  ),
                );
              },
              child: const ModuleBox(
                moduleName: 'Hindi Letters Pronunciation',
                difficulty: 'Beginner',
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NumbersPronunciation(),
                  ),
                );
              },
              child: const ModuleBox(
                moduleName: 'Numbers Pronunciation',
                difficulty: 'Beginner',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleBox extends StatelessWidget {
  const ModuleBox({
    super.key,
    required this.moduleName,
    required this.difficulty,
  });

  final String moduleName;
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(
          0.2,
        ), // Use AppColors.lightGreen
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.lightGreen.withOpacity(0.5),
        ), // Use AppColors.lightGreen
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            getModuleIcon(moduleName),
            size: 40,
            color: AppColors.darkGreen, // Use AppColors.darkGreen
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  moduleName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black, // Use AppColors.black
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Difficulty: $difficulty',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGreen, // Use AppColors.darkGreen
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to get appropriate icon for each module
  IconData getModuleIcon(String moduleName) {
    switch (moduleName) {
      case 'Hindi Letters Pronunciation':
        return Icons.record_voice_over;
      case 'Numbers Pronunciation':
        return Icons.calculate;
      default:
        return Icons.book;
    }
  }
}

class HindiLettersPronunciation extends StatelessWidget {
  const HindiLettersPronunciation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hindi Letters Pronunciation',
          style: TextStyle(color: AppColors.white), // Use AppColors.white
        ),
        backgroundColor: AppColors.primaryGreen, // Use AppColors.primaryGreen
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This is where the practice session for Hindi letters pronunciation will go.  You can add interactive elements, lists of letters, and pronunciation guides here.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
            ), // Use AppColors.black
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class NumbersPronunciation extends StatelessWidget {
  const NumbersPronunciation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Numbers Pronunciation',
          style: TextStyle(color: AppColors.white), // Use AppColors.white
        ),
        backgroundColor: AppColors.primaryGreen, // Use AppColors.primaryGreen
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This is where the practice session for Numbers pronunciation will go.  You can add interactive elements, lists of Numbers, and pronunciation guides here.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
            ), // Use AppColors.black
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
