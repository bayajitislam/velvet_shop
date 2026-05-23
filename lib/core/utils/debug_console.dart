import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class DebugConsole {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _grey = '\x1B[90m';

  static void _p(String text, {String name = 'APP'}) {
    if (kDebugMode) {
      developer.log(text, name: name);
    }
  }

  static void info(String m) => _p('$_cyan$m$_reset', name: 'INFO');
  static void success(String m) => _p('$_green$m$_reset', name: 'SUCCESS');
  static void warning(String m) => _p('$_yellow$m$_reset', name: 'WARNING');
  static void error(String m) => _p('$_red$m$_reset', name: 'ERROR');
  static void debug(String m) => _p('$_blue$m$_reset', name: 'DEBUG');
  static void api(String m) => _p('$_magenta$m$_reset', name: 'API');
  static void network(String m) => _p('$_blue$m$_reset', name: 'NETWORK');
  static void auth(String m) => _p('$_cyan$m$_reset', name: 'AUTH');
  static void storage(String m) => _p('$_white$m$_reset', name: 'STORAGE');
  static void nav(String m) => _p('$_magenta$m$_reset', name: 'NAV');
  static void ui(String m) => _p('$_grey$m$_reset', name: 'UI');

  static void red(String t) => error(t);
  static void green(String t) => success(t);
  static void yellow(String t) => warning(t);
  static void blue(String t) => debug(t);
  static void magenta(String t) => api(t);
  static void cyan(String t) => info(t);

  static void divider({String? label}) => _p(
    label != null
        ? '═══════════════ $label ═══════════════'
        : '═════════════════════════════════════════',
  );

  static void sectionStart(String n) =>
      _p('┌────────────── $n ──────────────┐');
  static void sectionEnd(String n) => _p('└────────────── $n ──────────────┘');

  static void object(String l, dynamic o) {
    _p('[$l]');
    _p('$o');
  }

  static void list(String l, List items) {
    _p('[$l] (${items.length} items)');
    for (var i = 0; i < items.length; i++) {
      _p('  [$i] ${items[i]}');
    }
  }

  static void map(String l, Map<String, dynamic> d) {
    _p('[$l]');
    d.forEach((k, v) => _p('  $k: $v'));
  }

  // title প্যারামিটার যোগ করা হয়েছে
  static void json({dynamic data,  String title = '', String label = 'JSON'}) {
    if (kDebugMode) {
      try {
        const encoder = JsonEncoder.withIndent('  ');
        final String prettyString = encoder.convert(data);

        // যদি টাইটেল দেওয়া থাকে, তবে আগে টাইটেল প্রিন্ট হবে (সাদা কালারে)
        if (title.isNotEmpty) {
          _p('$_white$title$_reset', name: label);
        }

        // এরপর JSON ডাটা প্রিন্ট হবে (সিয়ান কালারে)
        _p('$_cyan$prettyString$_reset', name: label);
      } catch (e) {
        _p('$_red$e$_reset', name: 'JSON ERROR');
      }
    }
  }
}
