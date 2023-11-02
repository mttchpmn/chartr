abstract class DataProvider<TData, TInput> {
  Future<TData> getData(TInput input);
}
