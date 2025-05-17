// settings.dart
import 'package:flutter/material.dart';
import 'package:deaf_dumb_app/styles.dart'; // Import the styles file

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

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
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Profile',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to profile settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Notifications',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to notifications settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Language',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to language settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'About Us',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to language settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Accessibility',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to accessibility settings
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccessibilitySettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Help & Support',
                style: TextStyle(color: AppColors.black),
              ),
              onTap: () {
                // Navigate to help and support
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpAndSupportPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Profile Settings Page
class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'Profile Settings Page',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}

// Placeholder for Notification Settings Page
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'Notification Settings Page',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}

// Placeholder for Language Settings Page
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language Settings',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'Language Settings Page',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}

// Placeholder for About Us Page
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'About Us',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}

// Placeholder for Accessibility Settings Page
class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accessibility',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'Accessibility Settings Page',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}

// Placeholder for Help & Support Page
class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: const Center(
        child: Text(
          'Help & Support Page',
          style: TextStyle(fontSize: 20, color: AppColors.black),
        ),
      ),
    );
  }
}
