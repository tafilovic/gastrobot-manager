import 'package:flutter/material.dart';

class PreparingScreen extends StatelessWidget {
  const PreparingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparing'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Preparing'),
            Text('Items in preparation', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
