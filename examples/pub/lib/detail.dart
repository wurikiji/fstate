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
  return pubRepository.getPackageDetails(
      packageName: packageName, cancelToken: cancelToken());
}

@fstate
Future<List<String>> likedPackages(
  @inject$PubRepository PubRepository pubRepository,
) async {
  return pubRepository.getLikedPackages(cancelToken: cancelToken());
}

@fstate
Future<PackageMetricsScore> packageMetrics({
  @inject$PubRepository required PubRepository pubRepository,
  required String packageName,
}) async {
  return pubRepository.getPackageMetrics(packageName: packageName);
}

/// The detail page of a package, typically reached by clicking on a package from [SearchPage].
@fwidget
class PackageDetailPage extends StatelessWidget {
  const PackageDetailPage({
    super.key,
    required this.packageName,
    @inject$fetchPackageDetails$ required this.package,
    @inject$likedPackages required this.likedPackages,
    @inject$packageMetrics$ required this.metrics,
    @inject$PubRepository required this.pubRepository,
  });

  /// The name of the package that is inspected.
  final String packageName;
  final Package package;
  final List<String> likedPackages;
  final PackageMetricsScore metrics;
  final PubRepository pubRepository;
  @override
  Widget build(BuildContext context) {
    final isLiked = likedPackages.contains(packageName);

    return Scaffold(
      appBar: const PubAppbar(),
      body: RefreshIndicator(
        onRefresh: () async {
          /// ** not yet supported on fstate **
          // return Future.wait([
          //   ref.refresh(
          //     packageMetricsProvider(packageName: packageName).future,
          //   ),
          //   ref.refresh(
          //     fetchPackageDetailsProvider(packageName: packageName).future,
          //   ),
          // ]);
        },
        child: PackageDetailBodyScrollView(
          packageName: packageName,
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
            await pubRepository.unlike(packageName: packageName);
          } else {
            await pubRepository.like(packageName: packageName);
          }
        },
        child: isLiked
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}
