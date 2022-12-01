// The purpose of this file is to conver the books title to a file name

Future<String> fileNameFromTitle(String title) async {
  String fileName = title.replaceAll(' ', '_');
  fileName = fileName.replaceAll('/', '_');
  fileName = fileName.replaceAll(':', '_');
  fileName = fileName.replaceAll('?', '_');
  fileName = fileName.replaceAll('*', '_');
  fileName = fileName.replaceAll('"', '_');
  fileName = fileName.replaceAll('<', '_');
  fileName = fileName.replaceAll('>', '_');
  fileName = fileName.replaceAll('-', '_');
  fileName = fileName.replaceAll('|', '_');
  fileName = fileName.replaceAll('!', '_');
  fileName = fileName.replaceAll(',', '_');
  fileName = fileName.replaceAll('\'', '');
  fileName = fileName.replaceAll('’', '');
  fileName = fileName.replaceAll('‘', '');
  fileName = fileName.replaceAll('“', '');
  fileName = fileName.replaceAll('”', '');
  fileName = fileName.replaceAll('"', '');
  fileName = fileName.replaceAll('(', '');
  fileName = fileName.replaceAll(')', '');
  fileName = fileName.replaceAll('[', '');
  fileName = fileName.replaceAll(']', '');
  fileName = fileName.replaceAll('{', '');
  fileName = fileName.replaceAll('}', '');
  fileName = fileName.replaceAll(';', '');
  fileName = fileName.replaceAll(':', '');
  // replace all periods minus the last one
  fileName = fileName.replaceAll('…', '');
  fileName = fileName.replaceAll('·', '');
  fileName = fileName.replaceAll('·', '');

  fileName = fileName.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
  return fileName;
}
