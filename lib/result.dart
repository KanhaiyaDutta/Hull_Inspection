import 'package:flutter/material.dart';
import 'package:hull_inspection/providers/image_provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});
  static const String route = '/results';

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ImagesProvider provider = ImagesProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Results')),
      body: Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: provider.uploadedImages.length,
          itemBuilder: (context, index) {
            return Image.network(provider.uploadedImages[index]);
          },
        ),
      ),
    );
  }
}
