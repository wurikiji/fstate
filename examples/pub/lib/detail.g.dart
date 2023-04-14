// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'detail.dart';

// **************************************************************************
// SelectorGenerator
// **************************************************************************

const inject$fetchPackageDetails$ = Finject(fetchPackageDetails, false);

Future<Package> _$fetchPackageDetails(
    {$setNextState,
    required PubRepository pubRepository,
    required String packageName}) async {
  final result = fetchPackageDetails(
      pubRepository: pubRepository, packageName: packageName);
  try {
    return ((await result) as dynamic).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}

class $fetchPackageDetails extends FstateFactory {
  $fetchPackageDetails({this.pubRepository, required this.packageName})
      : $stateKey = FstateKey('Future<Package>',
            [fetchPackageDetails, pubRepository, packageName]);

  final $PubRepository? pubRepository;
  final String packageName;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$fetchPackageDetails;

  @override
  List<Param> get $params => [
        Param.named(#pubRepository, pubRepository ?? $PubRepository()),
        Param.named(#packageName, packageName)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

const inject$likedPackages = Finject(likedPackages, true);

Future<List<String>> _$likedPackages(
    {$setNextState, required PubRepository pubRepository}) async {
  final result = likedPackages(pubRepository);
  try {
    return ((await result) as dynamic).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}

class $likedPackages extends FstateFactory {
  $likedPackages({this.pubRepository})
      : $stateKey =
            FstateKey('Future<List<String>>', [likedPackages, pubRepository]);

  final $PubRepository? pubRepository;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$likedPackages;

  @override
  List<Param> get $params =>
      [Param.named(#pubRepository, pubRepository ?? $PubRepository())];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

const inject$packageMetrics$ = Finject(packageMetrics, false);

Future<PackageMetricsScore> _$packageMetrics(
    {$setNextState,
    required PubRepository pubRepository,
    required String packageName}) async {
  final result =
      packageMetrics(pubRepository: pubRepository, packageName: packageName);
  try {
    return ((await result) as dynamic).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}

class $packageMetrics extends FstateFactory {
  $packageMetrics({this.pubRepository, required this.packageName})
      : $stateKey = FstateKey('Future<PackageMetricsScore>',
            [packageMetrics, pubRepository, packageName]);

  final $PubRepository? pubRepository;
  final String packageName;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$packageMetrics;

  @override
  List<Param> get $params => [
        Param.named(#pubRepository, pubRepository ?? $PubRepository()),
        Param.named(#packageName, packageName)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class $PackageDetailPage extends FstateWidget {
  const $PackageDetailPage(
      {required this.packageName,
      required this.package,
      required this.metrics,
      this.pubRepository,
      this.$onLoading,
      Key? key})
      : super(key: key);

  final String packageName;
  final $fetchPackageDetails package;
  final $packageMetrics metrics;
  final $PubRepository? pubRepository;

  @override
  List<Param> get $params => [
        Param.named(#key, key),
        Param.named(#packageName, packageName),
        Param.named(#package, package),
        Param.named(#metrics, metrics),
        Param.named(#pubRepository, pubRepository ?? $PubRepository())
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => PackageDetailPage.new;

  @override
  final Widget Function(BuildContext)? $onLoading;
}
