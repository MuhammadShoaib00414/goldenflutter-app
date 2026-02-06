enum ResStatus { loading, success, error }

class ApiResponse<T> {
  final ResStatus status;
  final T? data;
  final dynamic message;

  const ApiResponse._({
    required this.status,
    this.data,
    this.message,
  });

  /// Loading state
  factory ApiResponse.loading() {
    return const ApiResponse._(
      status: ResStatus.loading,
    );
  }

  /// Success state
  factory ApiResponse.success(T data) {
    return ApiResponse._(
      status: ResStatus.success,
      data: data,
    );
  }

  /// Error state
  factory ApiResponse.error(dynamic message) {
    return ApiResponse._(
      status: ResStatus.error,
      message: message,
    );
  }

  bool get isLoading => status == ResStatus.loading;
  bool get isSuccess => status == ResStatus.success;
  bool get isError => status == ResStatus.error;

  @override
  String toString() {
    return 'Status: $status\nMessage: $message\nData: $data';
  }
}
