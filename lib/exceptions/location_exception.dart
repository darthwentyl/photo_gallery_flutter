enum LocationExceptionCodes {
  unitiliaze, // when LocationController is not initialized.
}

class LocationException implements Exception {
  LocationException(this.code, this.description);

  LocationExceptionCodes code;
  String? description;

  @override
  String toString() => 'LocationException(${code.toString()}, $description)';
}
