// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;

/// Takes a file with a list of file paths, one per line, and returns the names
/// as paths in terms of the directory containing [fileName].
Iterable<String> linesFromFile(String? fileName) {
  if (fileName == null) {
    return [];
  }
  var file = File(fileName);
  return file
      .readAsLinesSync()
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .map((name) => _relativeToBase(fileName, name));
}

/// If [filename] is relative, make it relative to the dirname of base.
///
/// This is useful if we're running tests in a separate directory.
String _relativeToBase(String base, String filename) {
  if (path.isRelative(filename)) {
    return path.join(path.dirname(base), filename);
  } else {
    return filename;
  }
}

List<Directory> _findDirectories(List<String> paths) {
  final List<Directory> directories = <Directory>[];
  for (final String path in paths) {
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.directory) {
      directories.add(Directory(path));
    }
  }
  return directories;
}

Future<List<String>> findDartFilesInDirectories(
  List<String> paths,
) async {
  final List<Directory> directories = _findDirectories(paths);
  final List<String> dartFiles = <String>[];

  for (final Directory directory in directories) {
    final List<FileSystemEntity> entities =
        await directory.list(recursive: true).toList();
    final Iterable<FileSystemEntity> files = entities.where(_isDartFile);
    dartFiles.addAll(files.map((FileSystemEntity file) => file.path));
  }
  return dartFiles;
}

bool _isDartFile(FileSystemEntity entity) {
  return entity is File && entity.path.endsWith(".dart");
}
