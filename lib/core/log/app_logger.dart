import 'package:flutter/foundation.dart';

/// Parses a stack trace frame line to extract location (file, line, member).
/// Frame format: "#1      ClassName.methodName (package:.../file.dart:123:45)"
void _parseFrame(String frameLine, void Function(String file, int line, String member) onParsed) {
  final lineMatch = RegExp(r'[/\\]([^/\\]+\.dart):(\d+):\d+\)').firstMatch(frameLine);
  final memberMatch = RegExp(r'#\d+\s+(.+?)\s+\(').firstMatch(frameLine);
  final file = lineMatch?.group(1) ?? 'unknown';
  final line = int.tryParse(lineMatch?.group(2) ?? '0') ?? 0;
  final member = memberMatch?.group(1)?.trim() ?? 'unknown';
  onParsed(file, line, member);
}

/// Returns a short location prefix for the caller of debugLog.
/// Stack: 0=_locationPrefix, 1=debugLog, 2=actual caller → we use frame 2.
/// [stackOffset] 0 = caller of debugLog, 1 = caller's caller, etc.
String _locationPrefix([int stackOffset = 0]) {
  final stack = StackTrace.current;
  final lines = stack.toString().trim().split('\n');
  const framesToSkip = 2; // skip _locationPrefix and debugLog
  final frameIndex = framesToSkip + stackOffset;
  if (lines.length <= frameIndex) return '[?:?] ?';
  String? file;
  int line = 0;
  String member = '?';
  _parseFrame(lines[frameIndex], (f, l, m) {
    file = f;
    line = l;
    member = m;
  });
  return '[$file:$line] $member';
}

/// Logs [message] in debug mode with a prefix: [fileName:lineNumber] ClassName.methodName
/// so logs are easier to trace (class, function, line).
void debugLog(String message, {int stackOffset = 0}) {
  if (!kDebugMode) return;
  final prefix = _locationPrefix(stackOffset);
  debugPrint('$prefix | $message');
}
