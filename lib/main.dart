import 'dart:html';
import 'package:hull_inspection/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:hull_inspection/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hull_inspection/result.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ImagesProvider>(create: (context) => ImagesProvider()),
        Provider<ThemeProvider>(create: (context) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, _) => MaterialApp(
          routes: {
            MyHomePage.route: (context) => MyHomePage(),
            ResultPage.route: (context) => ResultPage(),
          },
          title: 'Image Uploader',
          theme: provider.themeData,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const route = '/';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hull Inspection'),
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
      body: Consumer<ImagesProvider>(
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
                    return Center(
                      child: Stack(
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
                      ),
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
                        Navigator.pushNamed(context, ResultPage.route);
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
    );
  }
}
