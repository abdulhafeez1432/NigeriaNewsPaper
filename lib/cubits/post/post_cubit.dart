import 'package:NewsApp/models/post.dart';
import 'package:NewsApp/networking/api_exceptions.dart';
import 'package:NewsApp/repositories/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostResponse postResponse;
  final PostRepository postRepository;

  PostCubit({@required this.postRepository}) : super(PostInitial());

  Future<void> getPosts({String category}) async {
    emit(PostLoading());
    try {
      postResponse = await postRepository.getPosts(category: category);
      emit(PostFetched(postResponse: postResponse));
    } on AppException catch (e) {
      emit(PostFetchedError(errorMessage: e.message));
    }
  }

  Future<void> getSitePosts({@required String siteName}) async {
    emit(PostLoading());
    try {
      postResponse = await postRepository.getSitePosts(siteName: siteName);
      emit(PostFetched(postResponse: postResponse));
    } on AppException catch (e) {
      emit(PostFetchedError(errorMessage: e.message));
    }
  }

  Future<void> getSearchPosts({@required String searchQuery}) async {
    emit(PostLoading());
    try {
      postResponse = await postRepository.getSearchPosts(searchQuery: searchQuery);
      emit(PostFetched(postResponse: postResponse));
    } on AppException catch (e) {
      emit(PostFetchedError(errorMessage: e.message));
    }
  }
}
