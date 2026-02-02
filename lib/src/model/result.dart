sealed class Result<T> {
  const Result();

  factory Result.ok(T data) => Ok(data);

  factory Result.failure(Exception error, {StackTrace? trace}) =>
      Failure(error, trace: trace);

  bool get isOk => this is Ok;

  bool get isError => this is Failure;

  Ok<T> get asOk => this as Ok<T>;

  Failure<T> get asFailure => this as Failure<T>;
}

class Ok<T> extends Result<T> {
  final T data;

  Ok(this.data);
}

class Failure<T> extends Result<T> {
  final Exception error;
  StackTrace? trace;

  Failure(this.error, {this.trace});
}
