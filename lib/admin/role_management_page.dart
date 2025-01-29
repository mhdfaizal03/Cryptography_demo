import 'package:flutter/material.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({super.key});

  @override
  State<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  // This variable tracks which view is currently selected: 0 for List Roles, 1 for Add Role
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the Role Management page
            Text(
              'Role Management',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ), // Space between title and toggle buttons
            // Toggle buttons to switch between List Roles and Add Role
            ToggleButtons(
              borderRadius: BorderRadius.circular(5),
              selectedColor: Colors.black,
              fillColor: Colors.grey,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('List Roles'), // Button for listing roles
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Add Role'), // Button for adding a role
                ),
              ],
              isSelected: [
                selectedIndex == 0,
                selectedIndex == 1,
              ], // Highlight selected button
              onPressed: (int index) {
                setState(() {
                  selectedIndex = index; // Update the selected index
                });
              },
            ),
            const SizedBox(
              height: 20,
            ), // Space between toggle buttons and content
            // Show the appropriate view based on the selected index
            buildView(), // Call the method to get the correct view
          ],
        ),
      ),
    );
  }

  // Method to build the view for listing roles
  Widget _buildListRolesView() {
    return Expanded(
      child: ListView(
        children: [
          ListTile(title: Text('Role 1')), // Example role
          ListTile(title: Text('Role 2')), // Example role
          ListTile(title: Text('Role 3')), // Example role
          // Add more roles as needed
        ],
      ),
    );
  }

  // Method to build the view for adding a new role
  Widget _buildAddRoleView() {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Role Name',
                ), // Input field for role name
              ),
              const SizedBox(
                height: 10,
              ), // Space between input field and button
              ElevatedButton(
                onPressed: () {
                  // Handle role addition logic here
                  print(
                    'Role added',
                  ); // Replace with actual logic to add the role
                },
                child: const Text('Add Role'), // Button to add the role
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the appropriate view based on the selected index
  Widget buildView() {
    if (selectedIndex == 0) {
      return _buildListRolesView(); // Show the list of roles
    } else {
      return _buildAddRoleView(); // Show the form to add a role
    }
  }
}
