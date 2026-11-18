enum Status { initial, loading, success, error }

class Resources<T> {
  late final Status status;
  late final T? data;
  late final String? message;

  Resources._();

  Resources.init() {
    status = Status.initial;
    data = null;
    message = null;
  }

  Resources.loading() {
    status = Status.loading;
    data = null;
    message = null;
  }

  Resources.error(this.message, {this.data}) {
    status = Status.error;
  }

  Resources.success(this.data) {
    status = Status.success;
    message = null;
  }
}
