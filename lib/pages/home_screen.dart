import 'package:encrypt_decrypt_app/pages/document_screen.dart';
import 'package:encrypt_decrypt_app/pages/image_screen.dart';
import 'package:encrypt_decrypt_app/pages/video_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter App Demo"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VideoScreen()));
                },
                icon: const Icon(Icons.video_file),
                label: const Text("Select Video")),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ImageScreen()));
                },
                icon: const Icon(Icons.image_rounded),
                label: const Text("Select Image")),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DocumentScreen()));
                },
                icon: const Icon(Icons.insert_drive_file_rounded),
                label: const Text("Select Document"))
          ],
        ),
      ),
    );
  }
}
