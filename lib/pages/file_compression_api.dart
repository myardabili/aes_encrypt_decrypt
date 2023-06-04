import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:video_compress/video_compress.dart';

class FileCompressionApi {
  //Compressing the picked image
  static Future<File?> compressImage(File file) async {
    try {
      final compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 100, percentage: 10);
      return File(compressedFile.path);
    } catch (e) {
      return null; //If any error occurs during compression, the process is stopped.
    }
  }

//Compressing the picked video
  static Future<MediaInfo?> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);
      return VideoCompress.compressVideo(file.path,
          quality: VideoQuality.LowQuality,
          includeAudio: true,
          deleteOrigin: true);
    } catch (e) {
      VideoCompress
          .cancelCompression(); //If any error occurs during compression, the process is stopped.
    }
    return null;
  }
}
