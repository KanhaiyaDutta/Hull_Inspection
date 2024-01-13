import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageProvider(),
      child: MaterialApp(
        title: 'Image Uploader',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Uploader',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hull Inspection'),
          actions: [
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('AR/V Visualization'),
                onTap: () {
                  // Handle drawer item tap
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Handle drawer item tap
                },
              ),
              // Add more ListTile widgets for additional drawer items
            ],
          ),
        ),
        body: Consumer<ImageProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: provider.selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.memory(provider.selectedImages[index]),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.close_sharp,
                                color: Colors.black87,
                              ),
                              onPressed: () {
                                provider.removeImage(index);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          provider.pickImages();
                        },
                        child: Text('Pick Images'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.uploadImages();
                        },
                        child: Text('Upload Images'),
                      ),
                    ],
                  ),
                ),

                //For Recieved Images
                // Expanded(
                //   child: GridView.builder(
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 3,
                //     ),
                //     itemCount: provider.uploadedImages.length,
                //     itemBuilder: (context, index) {
                //       return Image.network(provider.uploadedImages[index]);
                //     },
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ImageProvider with ChangeNotifier {
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
