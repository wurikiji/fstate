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
  @inject$PubRepository required PubRepository pubRepository,
  required int page,
}) async {
  assert(page > 0, 'page offset starts at 1');
  final token = cancelToken();

  return pubRepository.getPackages(page: page, cancelToken: token);
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
                  print("Build $index");
                  try {
                    return searchController.text.isNotEmpty
                        ? $SearchList(
                            packages: $searchPackages(
                              page: page,
                              search: searchController.text,
                            ),
                            indexInPage: indexInPage,
                            $onLoading: (context) {
                              return PackageItemShimmer();
                            },
                            $onError: (p0, error) {
                              return Center(
                                child: Text('Error $error'),
                              );
                            },
                          )
                        : $PackageList(
                            packages: $fetchPackages(page: page),
                            indexInPage: indexInPage,
                            $onLoading: (p0) => PackageItemShimmer(),
                            $onError: (p0, error) {
                              return Center(
                                child: Text('Error $error'),
                              );
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
class SearchList extends StatelessWidget {
  SearchList({
    @inject$searchPackages$ required this.packages,
    required this.indexInPage,
  }) : assert(indexInPage < packages.length) {
    if (indexInPage >= packages.length) {
      throw 'indexInPage $indexInPage is out of bounds';
    }
  }

  final List<SearchPackage> packages;
  final int indexInPage;

  @override
  Widget build(BuildContext context) {
    final package = packages[indexInPage];

    return $PackageItem(
      package: $fetchPackageDetails(packageName: package.package),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            return $PackageDetailPage(
              metrics: $packageMetrics(packageName: package.package),
              package: $fetchPackageDetails(packageName: package.package),
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

@fwidget
class PackageList extends StatelessWidget {
  PackageList({
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

    return $PackageItem(
      package: $fetchPackageDetails(packageName: package.name),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            return $PackageDetailPage(
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
