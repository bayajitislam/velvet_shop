import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velvet/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Init persistent local storage ──────────────────
  await GetStorage.init();

  // ── Init app ───────────────────────────────────────
  runApp(const App());
}
