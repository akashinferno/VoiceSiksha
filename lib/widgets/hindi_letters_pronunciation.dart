import 'dart:async';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:deaf_dumb_app/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  bool _showCorrectPopup = false; // Added for popup
  String _correctPopupText = "";

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;
  StreamSubscription? _recorderSubscription;

  bool _isRecorderInitialized = false;
  String _recorderStatusMessage = "Initializing recorder...";
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _initializeRecorder() async {
    if (mounted) {
      setState(() {
        _isRecorderInitialized = false;
        _recorderStatusMessage = "Initializing recorder, please wait...";
      });
    }

    try {
      var status = await Permission.microphone.request();

      if (status.isGranted) {
        print('Microphone permission granted.');
        await _recorder!.openRecorder();
        _recorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            _isRecorderInitialized = true;
            _recorderStatusMessage = "Recorder ready.";
          });
        }
        print('FlutterSoundRecorder initialized.');
      } else {
        print('Microphone permission not granted. Status: $status');
        String message = 'Microphone permission required.';
        if (status.isPermanentlyDenied) {
          message += ' Please grant it in app settings.';
        } else if (status.isDenied) {
          message += ' Please grant permission when prompted.';
        } else if (status.isRestricted) {
          message = 'Microphone access is restricted on this device.';
        }
        if (mounted) {
          setState(() {
            _recorderStatusMessage = message;
            _isRecorderInitialized = false;
          });
        }
        return;
      }
    } catch (e) {
      print('Error initializing recorder: $e');
      if (mounted) {
        setState(() {
          _recorderStatusMessage =
              'Error initializing recorder. Please check logs or restart.';
          _isRecorderInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_isRecording && _recorder != null && _recorder!.isRecording) {
      _recorder!.stopRecorder().catchError((e) {
        print('Error stopping recorder during dispose: $e');
      });
    }
    _recorderSubscription?.cancel();
    _recorder?.closeRecorder().catchError((e) {
      print('Error closing recorder during dispose: $e');
    });
    _recorder = null;
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized || _recorder == null) {
      print('Recorder not initialized. Cannot start recording.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _recorderStatusMessage.isNotEmpty
                  ? _recorderStatusMessage
                  : 'Recorder not ready.',
            ),
          ),
        );
      }
      return;
    }

    try {
      Directory tempDir = await getTemporaryDirectory();
      String path =
          '${tempDir.path}/hindi_pronunciation_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder!.startRecorder(toFile: path, codec: Codec.aacADTS);

      _recorderSubscription = _recorder!.onProgress!.listen((e) {});

      if (mounted) {
        setState(() {
          _isRecording = true;
          _recordedFilePath = null;
        });
      }
      print('Recording started: $path');
    } catch (e) {
      print('Error starting recorder: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_recorder == null || !_recorder!.isRecording) {
      if (_isRecording && mounted) setState(() => _isRecording = false);
      return;
    }
    try {
      final path = await _recorder!.stopRecorder();
      await _recorderSubscription?.cancel();
      _recorderSubscription = null;

      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordedFilePath = path;
        });
      }
      print('Recording stopped. File saved at: $_recordedFilePath');
      if (_recordedFilePath != null) {
        _processPronunciationAttempt();
      }
    } catch (e) {
      print('Error stopping recorder: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: ${e.toString()}')),
        );
      }
    }
  }

  void _selectLevel(int level) {
    if (mounted) {
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
        _isRecording = false;
        _recordedFilePath = null;
        if (!_isRecorderInitialized) {
          _initializeRecorder();
        }
      });
    }
  }

  void _processPronunciationAttempt() {
    if (mounted) {
      setState(() {
        _awaitingScore = true;
      });
    }
  }

  void _submitScore(bool correct) {
    if (mounted) {
      setState(() {
        if (correct) {
          _score++;
          _showCorrectPopup = true; // Show popup
          _correctPopupText = "Correct!";
          _confettiController.play();
          Timer(const Duration(seconds: 2), () {
            // Hide after 2 seconds
            if (mounted) {
              setState(() {
                _showCorrectPopup = false;
              });
            }
          });
        }
        _moveToNextLetterOrEnd();
      });
    }
  }

  void _skipAndGoNext() {
    if (mounted) {
      setState(() {
        _moveToNextLetterOrEnd();
      });
    }
  }

  void _moveToNextLetterOrEnd() {
    if (mounted) {
      setState(() {
        _awaitingScore = false;
        _recordedFilePath = null;
        if (_currentIndex < _currentLevelLetters.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = _currentLevelLetters.length;
          _showCompletionDialog();
        }
      });
    }
  }

  void _resetPractice() {
    if (mounted) {
      setState(() {
        _selectedLevel = null;
        _currentLevelLetters = [];
        _currentIndex = 0;
        _score = 0;
        _awaitingScore = false;
        _isRecording = false;
        _recordedFilePath = null;
        _recorderStatusMessage = "Initializing recorder...";
        _isRecorderInitialized = false;
        _initializeRecorder();
      });
    }
  }

  void _showCompletionDialog() {
    if (!mounted || _currentLevelLetters.isEmpty) return;

    double percentageScore =
        _currentLevelLetters.isNotEmpty
            ? (_score / _currentLevelLetters.length * 100)
            : 0.0;
    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            AlertDialog(
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Letters Correct: $_score / ${_currentLevelLetters.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.primaryBlue,
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
                    foregroundColor: AppColors.darkBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: AppColors.darkBlue.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetPractice();
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              child: const SizedBox(),
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
            const Text(
              'Select a Level',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
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
          color: AppColors.lightBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grade_outlined, color: AppColors.darkBlue, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Level $levelNumber',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
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
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primaryBlue,
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
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_currentIndex < _currentLevelLetters.length ? _currentIndex + 1 : _currentLevelLetters.length} / ${_currentLevelLetters.length}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: AppColors.lightBlue.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryBlue,
          ),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 20),
        Text(
          'Current Score: ${currentDisplayScore.toStringAsFixed(0)} / 100',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildLetterView() {
    if (_currentLevelLetters.isEmpty ||
        _currentIndex >= _currentLevelLetters.length) {
      return const Center(
        child: Text("Practice complete or no level selected."),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.lightBlue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          _currentLevelLetters[_currentIndex],
          style: const TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
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
        if (_recordedFilePath != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Audio captured. Ready for ML analysis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        const SizedBox(height: 10),
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
                backgroundColor: AppColors.darkBlue,
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

  Widget _buildPronounceAndRecordControls() {
    bool canRecord = _isRecorderInitialized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElevatedButton.icon(
          icon: Icon(
            _isRecording ? Icons.stop_circle_outlined : Icons.mic,
            color: AppColors.white,
          ),
          label: Text(
            _isRecording ? 'Stop Recording' : 'Record Pronunciation',
            style: const TextStyle(color: AppColors.white),
          ),
          onPressed:
              canRecord
                  ? () {
                    if (_isRecording) {
                      _stopRecording();
                    } else {
                      _startRecording();
                    }
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isRecording
                    ? Colors.redAccent
                    : (canRecord ? AppColors.primaryBlue : Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (!canRecord && _recorderStatusMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _recorderStatusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isRecording ? null : _skipAndGoNext,
          style: TextButton.styleFrom(
            foregroundColor:
                _isRecording
                    ? AppColors.darkBlue.withOpacity(0.4)
                    : AppColors.darkBlue.withOpacity(0.8),
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

    _confettiController.play();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "🎉 Level $_selectedLevel Complete! 🎉",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
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
                backgroundColor: AppColors.primaryBlue,
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
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkBlue,
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
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Future<void> action =
                _isRecording && _recorder != null && _recorder!.isRecording
                    ? _stopRecording()
                    : Future.value();

            action.then((_) {
              if (mounted && Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            // Added stack for popup
            children: [
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
                            : _buildPronounceAndRecordControls(),
                      const SizedBox(height: 10),
                    ],
                  ),
              // Popup for "Correct!"
              if (_showCorrectPopup)
                Positioned(
                  top:
                      MediaQuery.of(context).size.height *
                      0.15, // Adjusted position
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              _correctPopupText,
                              textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: false,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
