// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'package_item.dart';

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class $PackageItem extends FstateWidget {
  const $PackageItem(
      {required this.package,
      this.onTap,
      this.$onLoading,
      this.$onError,
      Key? key})
      : super(key: key);

  final $fetchPackageDetails package;
  final void Function()? onTap;

  @override
  List<Param> get $params => [
        Param.named(#key, key),
        Param.named(#package, package),
        Param.named(#onTap, onTap)
      ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => PackageItem.new;

  @override
  final Widget Function(BuildContext)? $onLoading;

  @override
  final Widget Function(BuildContext, Object? error)? $onError;
}
