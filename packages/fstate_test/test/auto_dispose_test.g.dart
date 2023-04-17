// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose_test.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

const inject$Root = Finject(Root, true);

class _$Root implements Root {
  _$Root({required this.$setNextState}) : _state = Root.new();

  _$Root.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(Root) $setNextState;
  final Root _state;
}

class $Root extends FstateFactory {
  $Root() : $stateKey = FstateKey('Root', [Root.new]);

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Root.new;

  @override
  late final List<Param> $params = [];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  bool get $keepAlive => false;
}

extension RootToFstateExtension on Root {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Root.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}

const inject$Child = Finject(Child, true);

class _$Child implements Child {
  _$Child({required this.$setNextState, required Root root})
      : _state = Child.new(root);

  _$Child.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(Child) $setNextState;
  final Child _state;

  @override
  Root get root => _state.root;
}

class $Child extends FstateFactory {
  $Child({this.root}) : $stateKey = FstateKey('Child', [Child.new, root]);

  final $Root? root;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Child.new;

  @override
  late final List<Param> $params = [Param.named(#root, root ?? $Root())];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  bool get $keepAlive => false;
}

extension ChildToFstateExtension on Child {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Child.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}

const inject$Child2 = Finject(Child2, true);

class _$Child2 implements Child2 {
  _$Child2({required this.$setNextState, required Root root})
      : _state = Child2.new(root);

  _$Child2.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(Child2) $setNextState;
  final Child2 _state;

  @override
  Root get root => _state.root;
}

class $Child2 extends FstateFactory {
  $Child2({this.root}) : $stateKey = FstateKey('Child2', [Child2.new, root]);

  final $Root? root;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Child2.new;

  @override
  late final List<Param> $params = [Param.named(#root, root ?? $Root())];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  bool get $keepAlive => false;
}

extension Child2ToFstateExtension on Child2 {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Child2.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}

const inject$KeepAliveState = Finject(KeepAliveState, true);

class _$KeepAliveState implements KeepAliveState {
  _$KeepAliveState({required this.$setNextState})
      : _state = KeepAliveState.new();

  _$KeepAliveState.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(KeepAliveState) $setNextState;
  final KeepAliveState _state;
}

class $KeepAliveState extends FstateFactory {
  $KeepAliveState()
      : $stateKey = FstateKey('KeepAliveState', [KeepAliveState.new]);

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$KeepAliveState.new;

  @override
  late final List<Param> $params = [];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  bool get $keepAlive => true;
}

extension KeepAliveStateToFstateExtension on KeepAliveState {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$KeepAliveState.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class $TestWidget extends FstateWidget {
  $TestWidget(
      {this.child,
      this.child2,
      this.root,
      this.keepAliveState,
      this.$onLoading,
      this.$onError,
      Key? key})
      : super(key: key);

  final $Child? child;
  final $Child2? child2;
  final $Root? root;
  final $KeepAliveState? keepAliveState;

  @override
  late final List<Param> $params = [
    Param.named(#key, key),
    Param.named(#child, child ?? $Child()),
    Param.named(#child2, child2 ?? $Child2()),
    Param.named(#root, root ?? $Root()),
    Param.named(#keepAliveState, keepAliveState ?? $KeepAliveState())
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};

  @override
  Function get $widgetBuilder => TestWidget.new;

  @override
  final Widget Function(BuildContext)? $onLoading;

  @override
  final Widget Function(BuildContext, Object? error)? $onError;
}
