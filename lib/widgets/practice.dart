import 'package:flutter/material.dart';
import 'package:deaf_dumb_app/styles.dart'; // Import the styles file

class PracticeWidget extends StatelessWidget {
  const PracticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Removed ElevatedButton
            Text(
              'Modules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              // Added GestureDetector
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HindiLettersPronunciation(),
                  ),
                );
              },
              child: const ModuleBox(
                //Made the Module box clickable
                moduleName: 'Hindi Letters Pronunciation',
                difficulty: 'Beginner',
              ),
            ),
            // Add more module boxes here as needed.
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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withOpacity(
          0.2,
        ), // Light purple background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.lightPurple.withOpacity(0.5),
        ), // Light purple border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            moduleName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              const Text(
                'Difficulty: ',
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
              Text(
                difficulty,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This is where the practice session for Hindi letters pronunciation will go.  You can add interactive elements, lists of letters, and pronunciation guides here.',
            style: TextStyle(fontSize: 16, color: AppColors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
