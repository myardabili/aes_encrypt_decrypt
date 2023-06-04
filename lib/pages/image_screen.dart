import 'dart:io';

import 'package:encrypt_decrypt_app/pages/file_compression_api.dart';
import 'package:encrypt_decrypt_app/pages/file_picker_api.dart';
import 'package:encrypt_decrypt_app/pages/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File? image;
  File? compressedImage;
  bool isUploading = false;
  bool isCompressing = false;

  @override
  Widget build(BuildContext context) {
    final fileName =
        image != null ? (image!.path.split('/').last) : "No Image Selected";
    final fileSize = image != null
        ? (image!.lengthSync().roundToDouble() / 1048576).toStringAsFixed(2)
        : "";
    final compressedFileSize = compressedImage != null
        ? (compressedImage!.lengthSync().roundToDouble() / 1048576)
            .toStringAsFixed(2)
        : "";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Image"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    image != null ? "File Size: $fileSize MB" : "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    compressedImage != null
                        ? "Compressed File Size: $compressedFileSize MB"
                        : "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (image == null)
                    ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePickerApi.pickImage();
                          if (result == null) {
                            return;
                          }
                          final filePath = result.path;
                          setState(() {
                            image = File(filePath);
                          });
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Pick Image"))
                  else
                    (compressedImage == null)
                        ? ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isCompressing = true;
                              });
                              final result =
                                  await FileCompressionApi.compressImage(
                                      image!);
                              if (result == null) {
                                return;
                              }
                              final filePath = result.path;
                              setState(() {
                                compressedImage = File(filePath);
                                isCompressing = false;
                              });
                            },
                            child: isCompressing
                                ? const Text("Compressing...")
                                : const Text("Compress Image"))
                        : Column(
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    String url = compressedImage!.path;
                                    GallerySaver.saveImage(url,
                                            albumName: "Flutter App Demo")
                                        .whenComplete(() =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Saved to Gallery!"))));
                                  },
                                  icon: const Icon(Icons.download_rounded),
                                  label: const Text("Save to Gallery")),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    setState(() {
                                      isUploading = true;
                                    });
                                    await uploadImage().whenComplete(() {
                                      setState(() {
                                        isUploading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Uploaded Successfully!")));
                                    });
                                  },
                                  icon: const Icon(Icons.cloud_upload_rounded),
                                  label: isUploading
                                      ? const Text("Uploading...")
                                      : const Text("Upload to Firebase")),
                            ],
                          ),
                ],
              )),
        ));
  }

  Future uploadImage() async {
    if (compressedImage == null) return;
    var filePath = compressedImage!.path;
    var fileName = (filePath.split('/').last);
    final destination = "files/images/$fileName";

    await FirebaseApi.uploadFile(destination, compressedImage!);
  }
}
