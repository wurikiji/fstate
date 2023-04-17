import '../../fstate.dart';

abstract class Param<V> {
  const Param._(
    this.key,
    this.value,
  );

  final dynamic key;
  final V value;

  factory Param.positional(int index, V value) {
    return PositionalParam<V>._(index, value);
  }

  factory Param.named(Symbol key, V value) {
    return NamedParam<V>._(key, value);
  }

  @override
  int get hashCode => Object.hash(key, value);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PositionalParam && key == other.key && value == other.value);
  }
}

class PositionalParam<T> extends Param<T> {
  PositionalParam._(
    super.key,
    super.value,
  ) : super._();
}

class NamedParam<T> extends Param<T> {
  NamedParam._(
    super.key,
    super.value,
  ) : super._();
}

typedef ParamConstructor = Param<V> Function<V>(dynamic key, V value);

/// TODO: seperate query and command
/// query: Get stream if present
/// command: Put stream if absent
Param<Stream<Param>> calculateFstateFactoryParam(
  FstateStreamContainer container,
  Param param,
  ParamConstructor paramConstructor,
) {
  final factory = param.value as FstateFactory;
  final value = (container.contains(factory.$stateKey)
          ? container.get(factory.$stateKey)!
          : container.put(
              factory.$stateKey,
              factory.createStateStream(container),
            ))
      .map((event) => paramConstructor(param.key, event));
  return paramConstructor(param.key, value);
}

Iterable convertToPositionalParams(Iterable<Param> params) {
  final positional = params.whereType<PositionalParam>().toList()
    ..sort((a, b) => a.key - b.key);
  return positional.map((e) => e.value).toList();
}

Map<Symbol, dynamic> convertToNamedParams(Iterable<Param> params) {
  final named = params.whereType<NamedParam>();
  return Map<Symbol, dynamic>.fromEntries(
      named.map((e) => MapEntry(e.key, e.value)));
}
