import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

class GoogleDrivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Page'),
      ),
      body: GoogleDrivePageState(),
    );
  }
}

class GoogleDrivePageState extends StatefulWidget {
  @override
  _GoogleDrivePageStateState createState() => _GoogleDrivePageStateState();
}

class _GoogleDrivePageStateState extends State<GoogleDrivePageState> {
  final folderId = '1c_kvHjUZlIBGyvI-0Js0GWXvR9aPYZox';
  final apiKey = 'AIzaSyCDgFGEkS09GTumKEUBn30HS-p4oKTybwc';
  List<drive.File> files = [];

  @override
  void initState() {
    super.initState();
    _fetchFilesAndFolders();
  }

  Future<void> _fetchFilesAndFolders() async {
    final driveApi = drive.DriveApi(await getAuthClient());
    final files = await driveApi.files
        .list(q: "'$folderId' in parents and trashed=false");
    setState(() {
      this.files = files.files!;
    });
  }

  Future<http.Client> getAuthClient() async {
    // Implement the authentication flow here and return the authenticated client
    // Refer to the Googleapis documentation for setting up OAuth2.0 authentication
    // You can use the googleapis_auth package for authentication
    // For simplicity, we'll use a mock auth client here
    final mockAuthClient = auth.clientViaApiKey(apiKey);
    return mockAuthClient;
  }

  Future<void> _downloadFile(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    // Implement the code to save the file locally on the device
    // For example, you can use the path_provider package to get the local storage path
    // File localFile = File(localFilePath);
    // await localFile.writeAsBytes(response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return ListTile(
            title: Text(file.name ?? 'Unnamed File'),
            leading: Icon(file.mimeType == 'application/vnd.google-apps.folder'
                ? Icons.folder
                : Icons.insert_drive_file),
            onTap: () {
              if (file.mimeType != 'application/vnd.google-apps.folder') {
                _downloadFile(file.webViewLink!);
              } else {
                // Handle folder tap or navigate to the subfolder
              }
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoogleDrivePage(),
  ));
}
