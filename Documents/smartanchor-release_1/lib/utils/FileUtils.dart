import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smartanchor/debug/printme.dart';

import '../common/widgets.dart';
import 'PermissionController.dart';

class FileUtils extends GetxController {
  Future<File?> takeSelfieWithCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    File? pickedImage;
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
    }
    return pickedImage;
  }

  String fileToBase64(File file) {
    List<int> bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }

  PermissionController permissionController = Get.put(PermissionController());

  Future<File?> writeXlsxFromBase64(String base64String, String fileName) async {
    try {
      // todo:
      bool permissionGranted = await permissionController.isStoragePermissionGranted();

      if (!permissionGranted) {
        print("Permission to access storage denied.");
        return null;
      }

      Directory? appDocDir;

      // Platform-specific directories
      if (Platform.isAndroid) {
        appDocDir = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        appDocDir = await getApplicationSupportDirectory();
      }

      if (appDocDir == null) {
        print("Failed to get directory path.");
        return null;
      }

      String folderPath = '${appDocDir.path}/Best';

      if (!Directory(folderPath).existsSync()) {
        Directory(folderPath).createSync(recursive: true);
      }

      String filePath = '$folderPath/$fileName.xlsx';
      print(filePath);
      // Decode the base64 string to bytes
      Uint8List bytes = base64Decode(base64String);

      // Write the bytes to the file
      await File(filePath).writeAsBytes(bytes);

      print("File saved at $filePath");

      return File(filePath);
    } catch (e, r) {
      printErrors(e);
      print(r);

      return null;
    }
  }

  void openDownloadedFile(File? file) {
    if (file != null) {
      OpenFile.open(file.path);
    }
  }

  String generateFileName() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMddHHmmss');
    String formatted = formatter.format(now);
    return 'best_$formatted';
  }

  Future<String> xlsxToFileBase64(File? file) async {
    try {
      if (file != null) {
        List<int> bytes = file.readAsBytesSync();

        String base64 = base64Encode(bytes);

        return base64;
      } else {
        return '';
      }
    } catch (e, r) {
      printErrors(e);
      printErrors(r);
      return '';
    }
  }

  String getFileNameFromPath(String filePath) {
    return p.basename(filePath);
  }

  Future<File?> pickXlsxFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      Widgets().showToast("selection Canceled !!");
      // User canceled selection
      return null;
    }
  }

  Future<File?> takeFileWithGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front);
    File? pickedImage;
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
    }
    return pickedImage;
  }

  String getFilename(File file) {
    String fileName = file.path.split('/').last;
    return fileName;
  }

  String signatureToBase64(List<int> signatureData) {
    String signatureBase64 = base64Encode(signatureData);
    return signatureBase64;
  }
}
