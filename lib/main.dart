import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learnerscontributer/firebase_options.dart';
import 'package:learnerscontributer/learnerhome.dart';
import 'package:learnerscontributer/videoplay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyB_BoAdVBOfWtDnbpFuEXiAOct0N-Df-AU',
    appId: '1:1063575230281:web:d5e9c225b1547989b46c98',
    messagingSenderId: '1063575230281',
    projectId: 'video-calling-app-bd8da',
    authDomain: 'video-calling-app-bd8da.firebaseapp.com',
    storageBucket: 'video-calling-app-bd8da.appspot.com',
    measurementId: 'G-DPRX6CHZ51',
    ),
  );
  
  runApp(RunnerScreen());
}
class RunnerScreen extends StatelessWidget {
  const RunnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VideoListScreen(),
      ),
    );
  }
}
