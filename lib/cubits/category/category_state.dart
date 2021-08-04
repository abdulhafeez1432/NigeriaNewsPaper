part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryFetched extends CategoryState {
  final List<Category> categories;
  const CategoryFetched({@required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryFetchedError extends CategoryState {
  final String errorMessage;
  const CategoryFetchedError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}