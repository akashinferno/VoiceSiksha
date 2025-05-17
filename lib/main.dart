import 'package:flutter/material.dart';

void main() {
  runApp(VoiceUpApp());
}

class VoiceUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceSiksha',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final List<String> hindiLetters = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ'];
  final int totalLessons = 6;

  void nextLesson() {
    if (currentIndex < hindiLetters.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / totalLessons;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("VoiceUp"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.deepPurple,
              backgroundColor: Colors.grey[300],
              minHeight: 10,
            ),
            SizedBox(height: 15),
            Text(
              "Lesson ${currentIndex + 1} of $totalLessons",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0.0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Text(
                    hindiLetters[currentIndex],
                    key: ValueKey<int>(currentIndex),
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text("Pronounce"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 239, 120, 219),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: nextLesson,
              child: Text("Next"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 239, 120, 219),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30),
            if (progress == 1.0)
              Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 10),
                  Text(
                    "🎉 Lesson Completed!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Level", style: TextStyle(color: Colors.grey)),
                      Text(
                        "Beginner",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Score", style: TextStyle(color: Colors.grey)),
                      Text(
                        "${(progress * 100).toInt()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("XP", style: TextStyle(color: Colors.grey)),
                      Text(
                        "${currentIndex * 10}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
