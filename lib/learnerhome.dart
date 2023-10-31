import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedVideoFile;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/placeholder.mp4');
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _pickVideoFromGallery();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              child: const Text("Pick Video from Gallery"),
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          Text(
            "Preview",
            style: TextStyle(
              color: Colors.red,
              fontSize: 30,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (_selectedVideoFile != null)
            Container(
              width: double.infinity,
              height: 200,
              child: FutureBuilder(
                future: _videoController.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    );
                  } else {
                    return const Text("Loading video...");
                  }
                },
              ),
            ),
          if (_selectedVideoFile == null) const Text("Please select a video."),
          ElevatedButton(
            onPressed: () {
              if (_selectedVideoFile != null) {
                _videoController.seekTo(const Duration(seconds: 0));
                _videoController.play();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            child: const Text("Play"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedVideoFile != null) {
                _videoController.seekTo(const Duration(seconds: 0));
                _videoController.play();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            child: const Text("Replay"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              _uploadVideoToFirebase();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            child: const Text("UPLOAD VIDEO"),
          )
        ],
      ),
    );
  }

  Future _pickVideoFromGallery() async {
    final pickedVideoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideoFile != null) {
      final videoFile = File(pickedVideoFile.path);
      final videoController = VideoPlayerController.file(videoFile);
      setState(() {
        _selectedVideoFile = videoFile;
        _videoController = videoController;
      });
    }
  }

  Future _uploadVideoToFirebase() async {
    if (_selectedVideoFile != null) {
      final storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      final UploadTask uploadTask = storageRef.putFile(_selectedVideoFile!);

      await uploadTask.whenComplete(() {});
      final String downloadUrl = await storageRef.getDownloadURL();
      print('Video uploaded to Firebase Storage. Download URL: $downloadUrl');
    }
  }
}
