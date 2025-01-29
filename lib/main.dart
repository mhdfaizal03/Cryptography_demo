import 'package:cryptography_demo/admin/pages/admin_page.dart';
import 'package:flutter/material.dart';
import 'package:cryptography_demo/admin/pages/auth_page.dart';
import 'package:cryptography_demo/admin/user_management_page.dart';
import 'package:cryptography_demo/admin/client_management_page.dart';
import 'package:cryptography_demo/admin/work_management_page.dart';
import 'package:cryptography_demo/admin/pages/activity_logs_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Document Cryptography',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/admin',
      routes: {
        '/': (context) => const AuthPage(),
        '/admin': (context) => const AdminPage(),
        '/user_management': (context) => const UserManagementPage(),
        '/client_management': (context) => const ClientManagementPage(),
        '/work_management': (context) => const WorkManagementPage(),
        '/activity_logs': (context) => const ActivityLogsPage(),
      },
    );
  }
}

// Models
