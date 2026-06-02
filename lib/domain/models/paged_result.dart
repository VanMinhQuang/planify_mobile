class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.nextCursor,
    required this.hasNextPage,
    required this.totalCount,
  });

  final List<T> items;
  final String? nextCursor;
  final bool hasNextPage;
  final int totalCount;

  static PagedResult<T> fromJson<T>(
    dynamic json,
    T Function(Map<String, dynamic> item) fromJson,
  ) {
    final map = json as Map<String, dynamic>;
    final pageInfo = map['pageInfo'] as Map<String, dynamic>? ?? {};
    return PagedResult<T>(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      nextCursor: pageInfo['nextCursor'] as String?,
      hasNextPage: pageInfo['hasNextPage'] as bool? ?? false,
      totalCount: pageInfo['totalCount'] as int? ?? 0,
    );
  }
}
