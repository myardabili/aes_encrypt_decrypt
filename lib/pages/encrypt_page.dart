import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:encrypt_decrypt_app/core.dart';
import 'package:encrypt_decrypt_app/pages/file_encryption_api.dart';
import 'package:encrypt_decrypt_app/pages/file_picker_api.dart';
import 'package:encrypt_decrypt_app/pages/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class EncryptPage extends StatefulWidget {
  const EncryptPage({Key? key}) : super(key: key);

  @override
  State<EncryptPage> createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files/encrypt').listAll();
  }

  File? doc;
  bool isUploading = false;
  bool isEncrypting = false;

  @override
  Widget build(BuildContext context) {
    final fileName =
        doc != null ? (doc!.path.split('/').last) : "No Document Selected";
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Encrypt",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: Colors.green,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            (doc == null)
                ? const Column(
                    children: [],
                  )
                : Center(
                    child: Column(
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
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isEncrypting = true;
                              isUploading = true;
                            });
                            final result = await FileEncryptionApi.encryptFile(
                                doc!.readAsBytesSync());

                            final encryptedFileName =
                                '${fileName.substring(0, fileName.lastIndexOf('.'))}.txt';

                            await uploadEncryptedFile(
                                result!, encryptedFileName);
                          },
                          child: isEncrypting
                              ? const Text("Encrypting...")
                              : const Text("Encrypt"),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: FutureBuilder<ListResult>(
                future: futureFiles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final files = snapshot.data!.items;
                    return ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return ListTile(
                          title: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () => downloadFile(context, file),
                            icon: const Icon(Icons.download),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error occurred'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await FilePickerApi.pickDocument();
          if (result == null) {
            return;
          }
          final filePath = result.path;
          setState(() {
            doc = File(filePath);
          });
        },
        icon: const Icon(
          Icons.attach_file,
          color: Colors.white,
        ),
        label: const Text(
          "Select Document",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> uploadEncryptedFile(
      Uint8List encryptedData, String fileName) async {
    final destination = "files/encrypt/$fileName";
    try {
      // Membuat referensi Firebase Storage
      final Reference ref = FirebaseStorage.instance.ref().child(destination);

      // Mengunggah file yang dienkripsi ke Firebase Storage
      await ref.putData(encryptedData);

      // Mendapatkan URL unduhan file yang diunggah
      final String downloadURL = await ref.getDownloadURL();

      // Menampilkan URL unduhan file
      print('Download URL: $downloadURL');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully encrypted and uploaded!")),
      );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
          (route) => false);
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload encrypted file")),
      );
    } finally {
      setState(() {
        isEncrypting = false;
        isUploading = false;
      });
    }
  }

  Future<void> downloadFile(BuildContext context, Reference ref) async {
    try {
      final url = await ref.getDownloadURL();
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));

      // Mendapatkan direktori download perangkat
      final downloadDir = Platform.isAndroid
          ? await getExternalStorageDirectory() // Android
          : await getDownloadsDirectory(); // iOS

      final savePath = '${downloadDir!.path}/${ref.name}';
      final file = File(savePath);
      await file.writeAsBytes(response.data);
      print(savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded ${ref.name}')),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download file')),
      );
    }
  }
}
