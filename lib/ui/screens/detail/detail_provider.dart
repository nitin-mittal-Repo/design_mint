
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//
// try {
// final path = await downloadRepoZip(
// repoUrl: 'https://github.com/nitin-mittal-Repo/daily_routine_flow_project',
// token: '',
// branch: 'master',
// onProgress: (p) {
// if (!mounted) return;
// setState(() => _progress = p);
// },
// );
//
// if (!mounted) return;
// setState(() {
// _progress = null;
// _downloadedPath = path;
// });
//
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Saved to $path')),
// );
// } catch (e) {
// if (!mounted) return;
// setState(() => _progress = null);
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Error: $e')),
// );
// }



Future<String> downloadRepoZip({
  required String repoUrl,
  required String token,
  String branch = 'main',
  void Function(double progress)? onProgress,
}) async {
  final uri = Uri.parse(repoUrl);
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.length < 2) throw Exception('Invalid repo URL: $repoUrl');

  final owner = segments[0];
  final repo = segments[1].replaceAll('.git', '');

  late Uri downloadUrl;
  final headers = <String, String>{'User-Agent': 'FlutterApp'};

  if (token.isNotEmpty) {
    downloadUrl = Uri.parse('https://api.github.com/repos/$owner/$repo/zipball/$branch');
    headers['Authorization'] = 'token $token';
    headers['Accept'] = 'application/vnd.github+json';
  } else {
    downloadUrl = Uri.parse('https://github.com/$owner/$repo/archive/refs/heads/$branch.zip');
  }

  final client = http.Client();
  try {
    var request = http.Request('GET', downloadUrl)..headers.addAll(headers);
    request.followRedirects = false;
    var streamedResponse = await client.send(request);

    int redirectCount = 0;
    while (streamedResponse.isRedirect && redirectCount < 5) {
      final location = streamedResponse.headers['location'];
      if (location == null) throw Exception('Redirect with no location header');
      streamedResponse = await client.send(
        http.Request('GET', Uri.parse(location))..headers.addAll(headers),
      );
      redirectCount++;
    }

    if (streamedResponse.statusCode != 200) {
      throw Exception('Failed to download repo: HTTP ${streamedResponse.statusCode}');
    }

    // --- progress tracking ---
    final contentLength = streamedResponse.contentLength ?? 0;
    final bytes = <int>[];
    int received = 0;

    await for (final chunk in streamedResponse.stream) {
      bytes.addAll(chunk);
      received += chunk.length;

      if (onProgress != null) {
        if (contentLength > 0) {
          onProgress(received / contentLength); // determinate 0.0 - 1.0
        } else {
          onProgress(-1); // unknown size -> indeterminate
        }
      }
    }
    // -------------------------

    final fileName = '$repo-$branch.zip';
    final savedPath = await _saveToDownloads(fileName, bytes);
    return savedPath;
  } finally {
    client.close();
  }
}


const _downloadsChannel = MethodChannel('downloads_channel');
Future<String> _saveToDownloads(String fileName, List<int> bytes) async {
  if (Platform.isAndroid) {
    final path = await _downloadsChannel.invokeMethod<String>(
      'saveToDownloads',
      {
        'fileName': fileName,
        'bytes': Uint8List.fromList(bytes),
      },
    );
    return path!;
  } else if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  } else {
    final dir = await getDownloadsDirectory();
    final file = File('${dir!.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}