class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<FieldError>? errors;
  final DateTime? timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] != null
          ? (json['errors'] as List)
                .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  /// Handle paging explicitly if data is a paging model
  factory ApiResponse.fromPagedJson(
    Map<String, dynamic> json,
    T Function(List<dynamic>) fromListT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data']['_embedded'] != null
          ? fromListT(json['data']['_embedded'].values.first as List)
          : (json['data'] != null && json['data']['content'] != null
                ? fromListT(json['data']['content'] as List)
                : null),
      errors: json['errors'] != null
          ? (json['errors'] as List)
                .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}

class FieldError {
  final String field;
  final String message;

  FieldError({required this.field, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: json['field'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
