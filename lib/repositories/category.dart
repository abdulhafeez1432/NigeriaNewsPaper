import 'package:NewsApp/networking/api_base_helper.dart';
import 'package:NewsApp/models/category.dart';

class CategoryRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  // final SharedPref _sharedPref = SharedPref();

  Future<List<Category>> getCategories() async {
    final Map<String, String> headers = _helper.configHeader();
    final response = await _helper.get(url: 'category/', headers: headers);
    return categoryFromJson(response as List);
  }
}
