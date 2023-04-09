import 'dart:async';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

@isTest
FutureOr<void> testWithLibraryReader(
  String testName,
  String source,
  FutureOr<void> Function(LibraryReader library, Resolver resolver, AssetId id)
      action,
) {
  test(testName, () async {
    await withLibraryReader(source, (library, resolver, id) async {
      await action(library, resolver, id);
    });
  });
}

@isTest
FutureOr<void> testWithResolver(
  String testName,
  String source,
  FutureOr<void> Function(Resolver resolver, AssetId id) action,
) {
  test(testName, () async {
    await withResolver(source, (resolver, id) async {
      await action(resolver, id);
    });
  });
}

FutureOr<void> withLibraryReader(
  String source,
  FutureOr<void> Function(LibraryReader library, Resolver resolver, AssetId id)
      action,
) {
  return withResolver(source, (resolver, id) async {
    await action(
      LibraryReader(await resolver.libraryFor(id, allowSyntaxErrors: true)),
      resolver,
      id,
    );
  });
}

FutureOr<void> withResolver(
  String source,
  FutureOr<void> Function(Resolver resolver, AssetId id) action,
) async {
  final id = makeAssetId();
  final completer = Completer();
  final resolver = resolveSource(
    source,
    (r) => r,
    inputId: id,
    tearDown: completer.future,
  );
  await action(await resolver, id);
  completer.complete();
}
