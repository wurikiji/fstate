String joinAlternatorsToMap(List<AlternatorArg> alternators) {
  return alternators
      .map((e) => '#${e.target}: ${e.alternatorName}')
      .join(',\n');
}

class AlternatorArg {
  AlternatorArg({
    required this.target,
    required this.alternatorName,
  });
  final String target;
  final String alternatorName;
}
