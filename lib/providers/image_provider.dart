import 'dart:html';

import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';

class ImagesProvider with ChangeNotifier {
  List<Uint8List> selectedImages = [];
  List<String> uploadedImages = [];

  Future<void> pickImages() async {
    try {
      final images = await ImagePickerWeb.getMultiImagesAsBytes();
      if (images != null) {
        selectedImages.addAll(images);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print('Failed to pick images: $e');
    }
  }

  void addImage(List<Uint8List> files) {
    for (var file in files) {
      final reader = FileReader();
      reader.onLoadEnd.listen((_) {
        selectedImages.add(reader.result as Uint8List);
        notifyListeners();
      });
      reader.readAsArrayBuffer(Blob(file));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  Future<void> uploadImages() async {
    // API call to upload images
    // ...

    // Dummy response
    uploadedImages = ['image1.jpg', 'image2.jpg', 'image3.jpg'];
    notifyListeners();
  }
}
