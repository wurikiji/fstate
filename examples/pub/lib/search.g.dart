// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'search.dart';

// **************************************************************************
// SelectorGenerator
// **************************************************************************

const inject$searchPackages$ = Finject(searchPackages, false);

Future<List<SearchPackage>?> _$searchPackages(
    {$setNextState,
    required PubRepository pubRepository,
    required int page,
    String search = ''}) async {
  final result =
      searchPackages(pubRepository: pubRepository, page: page, search: search);
  try {
    return ((await result) as dynamic).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}

class $searchPackages extends FstateFactory {
  $searchPackages({this.pubRepository, required this.page, this.search = ''})
      : $stateKey = FstateKey('Future<List<SearchPackage>?>',
            [searchPackages, pubRepository, page, search]);

  final $PubRepository? pubRepository;
  final int page;
  final String search;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$searchPackages;

  @override
  List<Param> get $params => [
        Param.named(#pubRepository, pubRepository ?? $PubRepository()),
        Param.named(#page, page),
        Param.named(#search, search)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

const inject$fetchPackages$ = Finject(fetchPackages, false);

Future<List<Package>> _$fetchPackages(
    {$setNextState,
    required PubRepository pubRepository,
    required int page}) async {
  final result = fetchPackages(pubRepository: pubRepository, page: page);
  try {
    return ((await result) as dynamic).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}

class $fetchPackages extends FstateFactory {
  $fetchPackages({this.pubRepository, required this.page})
      : $stateKey = FstateKey(
            'Future<List<Package>>', [fetchPackages, pubRepository, page]);

  final $PubRepository? pubRepository;
  final int page;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$fetchPackages;

  @override
  List<Param> get $params => [
        Param.named(#pubRepository, pubRepository ?? $PubRepository()),
        Param.named(#page, page)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class $SearchPage extends FstateWidget {
  const $SearchPage(
      {this.pubRepository, this.$onLoading, this.$onError, Key? key})
      : super(key: key);

  final $PubRepository? pubRepository;

  @override
  List<Param> get $params => [
        Param.named(#key, key),
        Param.named(#pubRepository, pubRepository ?? $PubRepository())
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => SearchPage.new;

  @override
  final Widget Function(BuildContext)? $onLoading;

  @override
  final Widget Function(BuildContext, Object? error)? $onError;
}

class $SearchList extends FstateWidget {
  const $SearchList(
      {required this.packages,
      required this.indexInPage,
      this.$onLoading,
      this.$onError,
      Key? key})
      : super(key: key);

  final $searchPackages packages;
  final int indexInPage;

  @override
  List<Param> get $params => [
        Param.named(#packages, packages),
        Param.named(#indexInPage, indexInPage)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => SearchList.new;

  @override
  final Widget Function(BuildContext)? $onLoading;

  @override
  final Widget Function(BuildContext, Object? error)? $onError;
}

class $PackageList extends FstateWidget {
  const $PackageList(
      {required this.packages,
      required this.indexInPage,
      this.$onLoading,
      this.$onError,
      Key? key})
      : super(key: key);

  final $fetchPackages packages;
  final int indexInPage;

  @override
  List<Param> get $params => [
        Param.named(#packages, packages),
        Param.named(#indexInPage, indexInPage)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => PackageList.new;

  @override
  final Widget Function(BuildContext)? $onLoading;

  @override
  final Widget Function(BuildContext, Object? error)? $onError;
}
