import 'package:NewsApp/networking/api_base_helper.dart';
import 'package:NewsApp/models/post.dart';
import 'package:meta/meta.dart';

class PostRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  // final SharedPref _sharedPref = SharedPref();

  Future<PostResponse> getPosts({String category}) async {
    final Map<String, String> headers = _helper.configHeader();
    final url = category != null ? 'allnewsbycategory/$category' : 'news/';
    print(url);
    final response = await _helper.get(url: url, headers: headers);
    return PostResponse.fromJson(response);
  }

  Future<PostResponse> getSitePosts({@required String siteName}) async {
    final Map<String, String> headers = _helper.configHeader();
    final response =
        await _helper.get(url: 'newsbymedia/$siteName', headers: headers);
    return PostResponse.fromJson(response);
  }

  Future<PostResponse> getSearchPosts({@required String searchQuery}) async {
    final Map<String, String> headers = _helper.configHeader();
    final response = await _helper.get(
        url: 'search',
        queryParameters: {'search': searchQuery},
        headers: headers);
    return PostResponse.fromJson(response);
  }
}
