
import 'package:url_launcher/url_launcher.dart';
import 'package:velvet/core/utils/debug_console.dart';

class AppUrlLauncher {
  /// Launches a URL safely.
  ///
  /// [url] The string URL to launch (e.g., 'http://google.com' or 'assets/file.pdf').
  ///
  /// Returns [Future<bool>] true if successful, false otherwise.
  static Future<bool> launchUrlString(String url) async {
    // 1. Validate and Parse URL
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      DebugConsole.error('UrlLauncher: Invalid URL format: $url');
      return false;
    }

    // 2. Check if platform can launch this URL type
    if (!await canLaunchUrl(uri)) {
      DebugConsole.error('UrlLauncher: Cannot launch URL: $url');
      return false;
    }

    // 3. Launch it
    // mode: LaunchMode.externalApplication ensures it opens in browser (Android/iOS)
    // instead of an in-app webview.
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
