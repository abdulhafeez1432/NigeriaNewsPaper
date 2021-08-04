import 'package:NewsApp/models/site.dart';
import 'package:NewsApp/networking/api_base_helper.dart';

class SiteRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  // final SharedPref _sharedPref = SharedPref();

  Future<List<Site>> getSites() async {
    final Map<String, String> headers = _helper.configHeader();
    final response = await _helper.get(url: 'site/', headers: headers);
    return siteFromJson(response as List);
  }
}