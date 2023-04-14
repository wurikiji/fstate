class Option {
  const Option();
  T when<T>({
    required T Function() none,
    required T Function(dynamic value) some,
  }) {
    if (this is Some) {
      return some((this as Some).value);
    }
    return none();
  }
}

class Some<T> extends Option {
  const Some(this.value);
  final T value;
}

class None extends Option {}
