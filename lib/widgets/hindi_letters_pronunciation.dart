import 'package:flutter/material.dart';
import 'package:deaf_dumb_app/styles.dart'; // Assuming AppColors is defined here

class HindiLettersPronunciation extends StatefulWidget {
  const HindiLettersPronunciation({super.key});

  @override
  State<HindiLettersPronunciation> createState() =>
      _HindiLettersPronunciationState();
}

class _HindiLettersPronunciationState extends State<HindiLettersPronunciation> {
  static const List<String> _level1Letters = [
    'अ',
    'आ',
    'इ',
    'ई',
    'उ',
    'ऊ',
    'ऋ',
    'ए',
    'ऐ',
    'ओ',
  ];
  static const List<String> _level2Letters = [
    'क',
    'ख',
    'ग',
    'घ',
    'ङ',
    'च',
    'छ',
    'ज',
    'झ',
    'ञ',
    'ट',
    'ठ',
    'ड',
    'ढ',
    'ण',
    'ड़',
    'ढ़',
    'त',
    'थ',
    'द',
    'ध',
    'न',
    'प',
    'फ',
    'ब',
    'भ',
    'म',
    'य',
    'र',
    'ल',
    'व',
    'श',
    'ष',
    'स',
    'ह',
    'क्ष',
    'त्र',
    'ज्ञ',
  ];

  List<String> _currentLevelLetters = [];
  int? _selectedLevel;
  int _currentIndex = 0;
  int _score = 0;
  bool _awaitingScore = false;

  void _selectLevel(int level) {
    setState(() {
      _selectedLevel = level;
      if (level == 1) {
        _currentLevelLetters = List.from(_level1Letters);
      } else if (level == 2) {
        _currentLevelLetters = List.from(_level2Letters);
      } else {
        _currentLevelLetters = [];
      }
      _currentIndex = 0;
      _score = 0;
      _awaitingScore = false;
    });
  }

  void _processPronunciationAttempt() {
    setState(() {
      _awaitingScore = true;
    });
  }

  void _submitScore(bool correct) {
    setState(() {
      if (correct) {
        _score++;
      }
      _moveToNextLetterOrEnd();
    });
  }

  void _skipAndGoNext() {
    setState(() {
      _moveToNextLetterOrEnd();
    });
  }

  void _moveToNextLetterOrEnd() {
    setState(() {
      _awaitingScore = false;
      if (_currentIndex < _currentLevelLetters.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = _currentLevelLetters.length;
        _showCompletionDialog();
      }
    });
  }

  void _resetPractice() {
    setState(() {
      _selectedLevel = null;
      _currentLevelLetters = [];
      _currentIndex = 0;
      _score = 0;
      _awaitingScore = false;
    });
  }

  void _showCompletionDialog() {
    if (_currentLevelLetters.isEmpty) return;

    double percentageScore =
        _currentLevelLetters.isNotEmpty
            ? (_score / _currentLevelLetters.length * 100)
            : 0.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            '🎉 Practice Complete!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Level $_selectedLevel',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Final Score: ${percentageScore.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Letters Correct: $_score / ${_currentLevelLetters.length}',
                style: TextStyle(fontSize: 16, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Practice Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetPractice();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.darkGreen.withOpacity(0.5)),
                ),
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetPractice();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLevelSelectionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Select a Level',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 40),
            _buildLevelButton(
              levelNumber: 1,
              levelName: 'Vowels',
              description: 'Learn the basic Hindi vowels (Svar)',
              onPressed: () => _selectLevel(1),
            ),
            const SizedBox(height: 20),
            _buildLevelButton(
              levelNumber: 2,
              levelName: 'Consonants',
              description: 'Practice Hindi consonants (Vyanjan)',
              onPressed: () => _selectLevel(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton({
    required int levelNumber,
    required String levelName,
    required String description,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grade_outlined,
                  color: AppColors.darkGreen,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Level $levelNumber',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              levelName,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primaryGreen,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressAndScore() {
    if (_currentLevelLetters.isEmpty) return const SizedBox.shrink();

    double progressValue =
        _currentLevelLetters.isNotEmpty
            ? (_currentIndex) / _currentLevelLetters.length.toDouble()
            : 0.0;
    if (_currentIndex == _currentLevelLetters.length &&
        _currentLevelLetters.isNotEmpty) {
      progressValue = 1.0;
    }

    double pointsPerCorrect =
        _currentLevelLetters.isNotEmpty
            ? 100.0 / _currentLevelLetters.length
            : 0;
    double currentDisplayScore = _score * pointsPerCorrect;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress (Level $_selectedLevel):',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_currentIndex < _currentLevelLetters.length ? _currentIndex + 1 : _currentLevelLetters.length} / ${_currentLevelLetters.length}',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: AppColors.lightGreen.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryGreen,
          ),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 20),
        Text(
          'Current Score: ${currentDisplayScore.toStringAsFixed(0)} / 100',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildLetterView() {
    if (_currentLevelLetters.isEmpty ||
        _currentIndex >= _currentLevelLetters.length) {
      return const Center(
        child: Text("Please select a level or practice complete."),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          _currentLevelLetters[_currentIndex],
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildScoringControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Did you pronounce it correctly?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text(
                'Incorrect',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _submitScore(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Correct',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _submitScore(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPronounceAndSkipControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElevatedButton(
          onPressed: _processPronunciationAttempt,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'I Have Pronounced',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _skipAndGoNext,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkGreen.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Text('Skip and Go to Next Letter'),
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    if (_currentLevelLetters.isEmpty) return const SizedBox.shrink();
    double percentageScore =
        _currentLevelLetters.isNotEmpty
            ? (_score / _currentLevelLetters.length * 100)
            : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "🎉 Level $_selectedLevel Complete! 🎉",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Text(
              'Final Score: ${percentageScore.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 22,
                color: AppColors.black.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Letters Correct: $_score / ${_currentLevelLetters.length}',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.black.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            ElevatedButton.icon(
              icon: const Icon(Icons.replay, color: AppColors.white),
              label: const Text(
                'Practice Again',
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
              onPressed: _resetPractice,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              child: const Text(
                'Go Back to Modules',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLevel == null
              ? 'Select Level'
              : 'Level $_selectedLevel: Hindi Letters',
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              _selectedLevel == null
                  ? _buildLevelSelectionScreen()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildProgressAndScore(),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child:
                              _currentLevelLetters.isNotEmpty &&
                                      _currentIndex >=
                                          _currentLevelLetters.length
                                  ? _buildCompletionView()
                                  : _buildLetterView(),
                        ),
                      ),
                      if (_currentLevelLetters.isNotEmpty &&
                          _currentIndex < _currentLevelLetters.length)
                        _awaitingScore
                            ? _buildScoringControls()
                            : _buildPronounceAndSkipControls(),
                      const SizedBox(height: 10),
                    ],
                  ),
        ),
      ),
    );
  }
}
