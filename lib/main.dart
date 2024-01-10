import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple Image Upload',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<html.File> _imageFiles = [];
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple Image Upload',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multiple Image Upload'),
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
                title: const Text('AR/VR Visualization'),
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Set the number of images per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _imageFiles.length,
                itemBuilder: (context, index) {
                  return Draggable<int>(
                    data: index,
                    feedback: Image.network(
                      html.Url.createObjectUrlFromBlob(_imageFiles[index]),
                      fit: BoxFit.cover,
                    ),
                    child: Image.network(
                      html.Url.createObjectUrlFromBlob(_imageFiles[index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _getImages(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: const Text(
                      'Select Images',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImages(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: const Text(
                      'Capture Images',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _uploadImages,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            _buildDragTarget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<int>(
      builder: (BuildContext context, List<int?> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          color: Colors.grey[200],
          height: 100.0,
          child: const Center(
            child: Text(
              'Drag and drop images here',
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          ),
        );
      },
      onAccept: (int? data) {
        // Handle the dropped item
        if (data != null && data >= 0 && data < _imageFiles.length) {
          // Update the _imageFiles list with the dropped image
          setState(() {
            _imageFiles.add(_imageFiles[data]);
          });
        }
      },
    );
  }

  Future<void> _getImages() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true; // Allow multiple file selection
    uploadInput.accept = 'image/*'; // Set accepted file types

    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _imageFiles += files;
        });
      }
    });
  }

  Future<void> _uploadImages() async {
    //   if (_imageFiles.isEmpty) {
    //     // Handle case when no images are selected
    //     return;
    //   }

    //   // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
    //   var url = Uri.parse('YOUR_API_ENDPOINT');

    //   // Create a multipart request
    //   var request = http.MultipartRequest('POST', url);

    //   // Attach each image to the request
    //   for (int i = 0; i < _imageFiles.length; i++) {
    //     request.files.add(http.MultipartFile.fromBytes('image$i', _imageFiles[i].slice(), filename: _imageFiles[i].name));
    //   }

    //   // Send the request
    //   var response = await request.send();

    //   // Check the status code of the response
    //   if (response.statusCode == 200) {
    //     // Images uploaded successfully
    //     print('Images uploaded successfully!');
    //   } else {
    //     // Handle the error
    //     print('Failed to upload images. Status code: ${response.statusCode}');
    //   }
  }
}
