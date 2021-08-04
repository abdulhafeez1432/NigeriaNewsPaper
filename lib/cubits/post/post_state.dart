part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostFetched extends PostState {
  final PostResponse postResponse;
  const PostFetched({@required this.postResponse});

  @override
  List<Object> get props => [postResponse];
}

class PostFetchedError extends PostState {
  final String errorMessage;
  const PostFetchedError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}