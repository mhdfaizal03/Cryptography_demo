import 'package:flutter/material.dart';

class ClientManagementPage extends StatelessWidget {
  const ClientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add client functionality
              },
              child: const Text('Add New Client'),
            ),
            // TODO: Implement client list and management functionalities
          ],
        ),
      ),
    );
  }
}
