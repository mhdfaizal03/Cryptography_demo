import 'package:flutter/material.dart';

class WorkManagementPage extends StatelessWidget {
  const WorkManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add work functionality
              },
              child: const Text('Add New Work'),
            ),
            // TODO: Implement work list and management functionalities
          ],
        ),
      ),
    );
  }
}
