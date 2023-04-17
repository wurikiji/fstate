import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';

import 'pub_repository.dart';
import 'pub_ui/appbar.dart';
import 'pub_ui/package_detail_body.dart';
import 'search.dart';

part 'detail.g.dart';

CancelToken cancelToken() {
  final cancelToken = CancelToken();

  // **not yet supported on fstate**
  // onDispose(cancelToken.cancel);
  return cancelToken;
}

@fstate
Future<Package> fetchPackageDetails({
  @inject$PubRepository required PubRepository pubRepository,
  required String packageName,
}) async {
  final result = await pubRepository.getPackageDetails(
      packageName: packageName, cancelToken: cancelToken());
  return result;
}

@fstate
Future<List<String>> likedPackages(
  @inject$PubRepository PubRepository pubRepository,
) async {
  final result =
      await pubRepository.getLikedPackages(cancelToken: cancelToken());
  return result;
}

@fstate
Future<PackageMetricsScore> packageMetrics({
  @inject$PubRepository required PubRepository pubRepository,
  required String packageName,
}) async {
  final result =
      await pubRepository.getPackageMetrics(packageName: packageName);
  return result;
}

/// The detail page of a package, typically reached by clicking on a package from [SearchPage].
@fwidget
class PackageDetailPage extends StatelessWidget {
  const PackageDetailPage({
    super.key,
    @inject$fetchPackageDetails$ required this.package,
    // @inject$likedPackages required this.likedPackages,
    @inject$packageMetrics$ required this.metrics,
    @inject$PubRepository required this.pubRepository,
  });

  /// The name of the package that is inspected.
  final Package package;
  // final List<String> likedPackages;
  final PackageMetricsScore metrics;
  final PubRepository pubRepository;
  @override
  Widget build(BuildContext context) {
    // final isLiked = likedPackages.contains(packageName);
    final isLiked = true;
    // print("detail page build: $packageName, $isLiked");

    return Scaffold(
      appBar: const PubAppbar(),
      body: RefreshIndicator(
        onRefresh: () async {
          pubRepository.refresh();
        },
        child: PackageDetailBodyScrollView(
          packageName: package.name,
          packageVersion: package.latest.version,
          packageDescription: package.latest.pubspec.description,
          grantedPoints: metrics.grantedPoints,
          likeCount: metrics.likeCount,
          maxPoints: metrics.maxPoints,
          popularityScore: metrics.popularityScore * 100,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isLiked) {
            await pubRepository.unlike(packageName: package.name);
          } else {
            await pubRepository.like(packageName: package.name);
          }
        },
        child: isLiked
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}
