enum FileExceptionCodes {
  external_storage_directory_does_not_exist,
}

class FileException implements Exception {
  FileException({required this.code, required this.description});

  FileExceptionCodes code;
  String description;

  @override
  String toString() => 'FileException(${code.toString()}, $description)';
}
