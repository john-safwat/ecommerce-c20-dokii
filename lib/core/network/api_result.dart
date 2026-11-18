sealed class Result<T> {
  T? data;

  Result(this.data);
}

class Success<T> extends Result<T> {
  Success(super.data);
}

class Failure<T> extends Result<T> {
  String message;
  Exception? exception;

  Failure(this.message, {this.exception, T? data}) : super(data);
}
