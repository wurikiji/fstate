import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fstate/fstate.dart';

import 'detail.dart';
import 'pub_repository.dart';
import 'pub_ui/appbar.dart';
import 'pub_ui/package_item.dart';
import 'pub_ui/searchbar.dart';

part 'search.g.dart';

const packagesPackageSize = 100;
const searchPageSize = 10;

@fstate
Future<List<SearchPackage>?> searchPackages({
  @inject$PubRepository required PubRepository pubRepository,
  required int page,
  String search = '',
}) async {
  if (search.isEmpty) return null;
  final token = cancelToken();
  return await pubRepository.searchPackages(
    page: page,
    search: search,
    cancelToken: token,
  );
}

@fstate
Future<List<Package>> fetchPackages({
  @inject$searchPackages$ required List<SearchPackage>? searchedPackages,
  @inject$PubRepository required PubRepository pubRepository,
  required int page,
}) async {
  assert(page > 0, 'page offset starts at 1');
  final token = cancelToken();

  if (searchedPackages == null) {
    return pubRepository.getPackages(page: page, cancelToken: token);
  }

  await Future<void>.delayed(const Duration(milliseconds: 250));

  return Future.wait([
    for (final package in searchedPackages)
      fetchPackageDetails(
        packageName: package.package,
        pubRepository: pubRepository,
      )
  ]);
}

@fwidget
class SearchPage extends HookWidget {
  const SearchPage({
    super.key,
    @inject$PubRepository required this.pubRepository,
  });
  final PubRepository pubRepository;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Scaffold(
      appBar: const PubAppbar(),
      body: Column(
        children: [
          SearchBar(controller: searchController),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                pubRepository.refresh();
              },
              child: ListView.custom(
                padding: const EdgeInsets.only(top: 30),
                childrenDelegate: SliverChildBuilderDelegate((context, index) {
                  final pageSize = searchController.text.isEmpty
                      ? packagesPackageSize
                      : searchPageSize;

                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;
                  try {
                    return $_PackageItemBuilder(
                      packages: $fetchPackages(
                        page: page,
                        searchedPackages: $searchPackages(
                          page: page,
                          search: searchController.text,
                        ),
                      ),
                      indexInPage: indexInPage,
                      $onLoading: (context) {
                        return PackageItemShimmer();
                      },
                    );
                  } catch (_) {
                    return null;
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@fwidget
class _PackageItemBuilder extends StatelessWidget {
  _PackageItemBuilder({
    @inject$fetchPackages$ required this.packages,
    required this.indexInPage,
  }) : assert(indexInPage < packages.length) {
    if (indexInPage >= packages.length) {
      throw 'indexInPage $indexInPage is out of bounds';
    }
  }

  final List<Package> packages;
  final int indexInPage;

  @override
  Widget build(BuildContext context) {
    final package = packages[indexInPage];

    return PackageItem(
      name: package.name,
      description: package.latest.pubspec.description,
      version: package.latest.version,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            return $PackageDetailPage(
              packageName: package.name,
              metrics: $packageMetrics(packageName: package.name),
              package: $fetchPackageDetails(packageName: package.name),
              $onLoading: (context) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
