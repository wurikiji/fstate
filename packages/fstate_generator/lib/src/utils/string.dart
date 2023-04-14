extension ToExtendedStateName on String {
  String toExtendedStateName() => '_\$$this';
}

extension WrapWithBracketsIfNotEmpty on String {
  String get wrappedWithBracketsIfNotEmpty => isEmpty ? '' : '{$this}';
}

extension ToFactoryName on String {
  String toFactoryName() {
    return '\$$this';
  }
}
