sealed class CommandResult<T> {
  const CommandResult();

  factory CommandResult.ok(T data) => Ok(data);

  factory CommandResult.failure(Exception error, {StackTrace? trace}) =>
      Failure(error, trace: trace);

  bool get isOk => this is Ok;

  bool get isError => this is Failure;

  Ok<T> get asOk => this as Ok<T>;

  Failure<T> get asFailure => this as Failure<T>;
}

class Ok<T> extends CommandResult<T> {
  final T data;

  Ok(this.data);
}

class Failure<T> extends CommandResult<T> {
  final Exception error;
  StackTrace? trace;

  Failure(this.error, {this.trace});
}
