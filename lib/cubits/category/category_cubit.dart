import 'package:NewsApp/models/category.dart';
import 'package:NewsApp/networking/api_exceptions.dart';
import 'package:NewsApp/repositories/category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;
  List<Category> categories = [];

  CategoryCubit({@required this.categoryRepository}) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      categories = await categoryRepository.getCategories();
      emit(CategoryFetched(categories: categories));
    } on AppException catch (e) {
      emit(CategoryFetchedError(errorMessage: e.message));
    }
  }
}
