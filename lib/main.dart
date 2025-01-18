import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() => runApp(const VisualCryptographyApp());

// Main App Widget
class VisualCryptographyApp extends StatelessWidget {
  const VisualCryptographyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Document Cryptography',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  );
}

// Models
class ShareData {
  final Uint8List bytes;
  final String fileName;

  ShareData(this.bytes, this.fileName);
}

// Visual Cryptography Logic
class DocumentCryptographyProcessor {
  static List<ShareData> generateShares(File documentFile) {
    final Uint8List documentBytes = documentFile.readAsBytesSync();
    final List<int> share1 = [];
    final List<int> share2 = [];

    for (int byte in documentBytes) {
      // Generate random byte for share1
      final int randomByte = (DateTime.now().microsecondsSinceEpoch % 256);
      share1.add(randomByte);
      // XOR the random byte with original byte to get share2
      share2.add(byte ^ randomByte);
    }

    String originalFileName = documentFile.path.split('/').last;
    return [
      ShareData(Uint8List.fromList(share1), 'share1_$originalFileName'),
      ShareData(Uint8List.fromList(share2), 'share2_$originalFileName'),
    ];
  }

  static Uint8List combineShares(List<Uint8List> shares) {
    if (shares.length != 2) throw Exception('Exactly 2 shares required');
    if (shares[0].length != shares[1].length) {
      throw Exception('Shares must be of equal length');
    }

    final List<int> combined = [];
    for (int i = 0; i < shares[0].length; i++) {
      combined.add(shares[0][i] ^ shares[1][i]);
    }

    return Uint8List.fromList(combined);
  }
}

// Main Page Widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Main Page State
class _HomePageState extends State<HomePage> {
  File? _document;
  List<ShareData>? _shares;
  Uint8List? _combinedDocument;
  bool _isProcessing = false;
  bool _isMixed = false;

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _document = File(result.files.single.path!);
          _shares = null;
          _combinedDocument = null;
          _isProcessing = true;
        });
        await _generateShares();
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      _showError('Error picking document: $e');
    }
  }

  Future<void> _generateShares() async {
    if (_document == null) return;

    try {
      final shares = DocumentCryptographyProcessor.generateShares(_document!);
      setState(() {
        _shares = shares;
      });
    } catch (e) {
      _showError('Error generating shares: $e');
    }
  }

  Future<String> _getDownloadsPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return '${directory!.path}/Documents/DocumentCrypto';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/DocumentCrypto';
    }
  }

  Future<void> _saveAndShareFile(Uint8List bytes, String fileName) async {
    if (!await Permission.manageExternalStorage.request().isGranted) {
      _showError('Storage permission is required');
      // Guide the user to the settings page
      openAppSettings();
      return;
    }

    try {
      final String dirPath = await _getDownloadsPath();
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final String filePath = '$dirPath/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(filePath)], text: 'Share $fileName');

      _showSuccess('File saved and ready to share');
    } catch (e) {
      _showError('Error saving file: $e');
    }
  }

  Future<void> _saveShare(ShareData share) async {
    if (!await Permission.manageExternalStorage.request().isGranted) {
      _showError('Storage permission is required');
      // Guide the user to the settings page
      openAppSettings();
      return;
    }
    await _saveAndShareFile(share.bytes, share.fileName);
  }

  Future<void> _saveCombinedDocument() async {
    if (_combinedDocument == null || _shares == null) return;

    if (!await Permission.manageExternalStorage.request().isGranted) {
      _showError('Storage permission is required');
      openAppSettings();
      return;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName;

      // Toggle between combined and mixed versions
      if (_isMixed) {
        // Create a mixed version of Share 1 and Share 2
        final mixedBytes = _mixShares(_shares![0].bytes, _shares![1].bytes);
        fileName = 'mixed_$timestamp.png'; // Change extension as needed
        await _saveAndShareFile(mixedBytes, fileName);
      } else {
        fileName = 'combined_$timestamp.png'; // Change extension as needed
        await _saveAndShareFile(_combinedDocument!, fileName);
      }

      // Toggle the state
      setState(() {
        _isMixed = !_isMixed;
      });
    } catch (e) {
      _showError('Error saving document: $e');
    }
  }

  Uint8List _mixShares(Uint8List share1, Uint8List share2) {
    final List<int> mixed = [];
    for (int i = 0; i < share1.length; i++) {
      mixed.add((share1[i] + share2[i]) ~/ 2); // Simple average for mixing
    }
    return Uint8List.fromList(mixed);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Cryptography'),
        actions: [
          if (_document != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _document = null;
                  _shares = null;
                  _combinedDocument = null;
                });
              },
              tooltip: 'Clear All',
            ),
        ],
      ),
      body:
          _isProcessing
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_document == null) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Select a document to start encrypting',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (_document != null) ...[
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(_document!.path.split('/').last),
                          subtitle: const Text('Original Document'),
                        ),
                      ),
                    ],
                    if (_shares != null) ...[
                      const SizedBox(height: 20),
                      ...List.generate(2, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.file_copy),
                              title: Text('Share ${index + 1}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () => _saveShare(_shares![index]),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          try {
                            final combined =
                                DocumentCryptographyProcessor.combineShares(
                                  _shares!.map((s) => s.bytes).toList(),
                                );
                            setState(() {
                              _combinedDocument = combined;
                            });
                          } catch (e) {
                            _showError('Error combining shares: $e');
                          }
                        },
                        icon: const Icon(Icons.merge_type),
                        label: const Text('Combine Shares'),
                      ),
                    ],
                    if (_combinedDocument != null) ...[
                      const SizedBox(height: 20),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            _isMixed ? 'Mixed Document' : 'Combined Document',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: _saveCombinedDocument,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isMixed = !_isMixed;
                          });
                        },
                        child: Text(_isMixed ? 'Show Combined' : 'Show Mixed'),
                      ),
                    ],
                  ],
                ),
              ),
      floatingActionButton:
          _document == null
              ? FloatingActionButton(
                onPressed: _pickDocument,
                tooltip: 'Pick Document',
                child: const Icon(Icons.file_upload),
              )
              : null,
    );
  }
}
