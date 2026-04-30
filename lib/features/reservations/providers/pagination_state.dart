class PaginationState {
  PaginationState({int initialPage = 1}) : _page = initialPage;

  int _page;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int get page => _page;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  int nextPage() => _page + 1;

  bool canLoadMore({required bool isLoading}) {
    return !isLoading && !_isLoadingMore && _hasMore;
  }

  void startLoadingMore() {
    _isLoadingMore = true;
  }

  void stopLoadingMore() {
    _isLoadingMore = false;
  }

  void markFetched({
    required int page,
    required int loadedItemsCount,
    required int total,
  }) {
    _page = page;
    _hasMore = loadedItemsCount < total;
    _isLoadingMore = false;
  }

  void updateHasMore({
    required int loadedItemsCount,
    required int total,
  }) {
    _hasMore = loadedItemsCount < total;
  }

  void reset({bool hasMore = true}) {
    _page = 1;
    _hasMore = hasMore;
    _isLoadingMore = false;
  }
}
