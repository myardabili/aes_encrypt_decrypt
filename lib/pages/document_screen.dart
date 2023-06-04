import 'dart:io';

import 'package:encrypt_decrypt_app/pages/file_encryption_api.dart';
import 'package:encrypt_decrypt_app/pages/file_picker_api.dart';
import 'package:encrypt_decrypt_app/pages/firebase_api.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  File? doc;
  bool isUploading = false;
  bool isEncrypting = false;
  bool isDecrypting = false;
  @override
  Widget build(BuildContext context) {
    final fileName =
        doc != null ? (doc!.path.split('/').last) : "No Document Selected";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Document"),
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
                    height: 10,
                  ),
                  (doc == null)
                      ? ElevatedButton.icon(
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
                          icon: const Icon(Icons.attach_file),
                          label: const Text("Select Document"))
                      : Column(
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isEncrypting = true;
                                  });
                                  final result =
                                      await FileEncryptionApi.encryptFile(
                                          doc!.readAsBytesSync());

                                  await FileSaver.instance
                                      .saveAs(
                                          bytes: result!,
                                          name: fileName,
                                          ext: "aes",
                                          mimeType: MimeType.other)
                                      .whenComplete(() {
                                    setState(() {
                                      isEncrypting = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Successfully encrypted!")));
                                  });
                                },
                                child: isEncrypting
                                    ? const Text("Encrypting...")
                                    : const Text("Encrypt Document")),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isDecrypting = true;
                                  });
                                  final result =
                                      await FileEncryptionApi.decryptedFile(
                                          doc!.readAsBytesSync());
                                  // final Uint8List? result =
                                  //     await FileEncryptionApi.decryptedFile(
                                  //         doc!.readAsBytesSync());
                                  await FileSaver.instance
                                      .saveAs(
                                          bytes: result!,
                                          name: fileName,
                                          ext: "pdf",
                                          mimeType: MimeType.other)
                                      .whenComplete(() {
                                    setState(() {
                                      isEncrypting = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Successfully decrypted!")));
                                  });
                                },
                                child: isEncrypting
                                    ? const Text("Decrypting...")
                                    : const Text("Decrypt Document")),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    isUploading = true;
                                  });
                                  await uploadDocument().whenComplete(() {
                                    setState(() {
                                      isUploading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
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

  Future uploadDocument() async {
    if (doc == null) return;
    var filePath = doc!.path;
    var fileName = (filePath.split('/').last);
    final destination = "files/documents/$fileName";

    await FirebaseApi.uploadFile(destination, doc!);
  }
}
