import 'package:NewsApp/cubits/category/category_cubit.dart';
import 'package:NewsApp/cubits/post/post_cubit.dart';
import 'package:NewsApp/cubits/site/site_cubit.dart';
import 'package:NewsApp/data.dart';
import 'package:NewsApp/details.dart';
import 'package:NewsApp/main.dart';
import 'package:NewsApp/networking/api_base_helper.dart';
import 'package:NewsApp/repositories/category.dart';
import 'package:NewsApp/repositories/post.dart';
import 'package:NewsApp/repositories/site.dart';
import 'package:NewsApp/services/utils.dart';
import 'package:NewsApp/widgets/customcachedimage.dart';
import 'package:NewsApp/widgets/empty_result.dart';
import 'package:NewsApp/widgets/error.dart';
import 'package:NewsApp/widgets/site_list_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:build_context/build_context.dart';

class Section extends StatefulWidget {
  String categoryName;
  bool isNotHomePage = true;

  Section({this.categoryName, this.isNotHomePage});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  final postCubit = PostCubit(postRepository: PostRepository());
  final allPostCubit = PostCubit(postRepository: PostRepository());
  final siteCubit = SiteCubit(siteRepository: SiteRepository());

  @override
  void initState() {
    if (widget.isNotHomePage) {
      siteCubit.getSites();
      allPostCubit.getPosts(category: widget.categoryName);
    } else {
      postCubit.getPosts(category: 'sport');
      siteCubit.getSites();
      allPostCubit.getPosts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              widget.isNotHomePage
                  ? Container()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.24,
                      child: BlocBuilder<PostCubit, PostState>(
                        cubit: postCubit,
                        builder: (context, state) {
                          if (state is PostLoading) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else if (state is PostFetched) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.postResponse.posts.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  final post = state.postResponse.posts[i];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => BlocProvider.value(
                                            value: postCubit,
                                            child: DetailsScreen(
                                              post: post,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.36,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            post.imageUrl,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.9)
                                            ],
                                            begin: Alignment.topCenter,
                                            stops: const [0.5, 1],
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Text(
                                              post.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              post.uploaded,
                                              style: context.textTheme.caption
                                                  .copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else if (state is PostFetchedError) {
                            return CustomErrorWidget(
                              errorMessage: 'Error Loading News',
                              onRetryPressed: () =>
                                  postCubit.getPosts(category: 'news'),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: BlocBuilder<SiteCubit, SiteState>(
                  cubit: siteCubit,
                  builder: (context, state) {
                    if (state is SiteLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else if (state is SiteFetched) {
                      return SitesListView(
                        sites: state.sites,
                      );
                    } else if (state is SiteFetchedError) {
                      return CustomErrorWidget(
                        errorMessage: 'Error Loading Sites',
                        onRetryPressed: () => siteCubit.getSites(),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              SizedBox(
                child: BlocBuilder<PostCubit, PostState>(
                  cubit: allPostCubit,
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else if (state is PostFetched) {
                      return state.postResponse.posts.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: EmptyResult(
                                leading:
                                    'Empty ${Utils.capitalizeFirstLetter(widget.categoryName)} Feed',
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.postResponse.posts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) {
                                final post = state.postResponse.posts[i];
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: allPostCubit,
                                              child: DetailsScreen(
                                                post: post,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: post.imageUrl.isEmpty
                                              ? const Icon(
                                                  Icons.book_online_rounded,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child:
                                                      CustomCachedNetworkImage(
                                                    imageUrl: post.imageUrl,
                                                    boxFit: BoxFit.cover,
                                                    boxShape:
                                                        BoxShape.rectangle,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                post.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                post.uploaded,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is PostFetchedError) {
                      return CustomErrorWidget(
                        errorMessage: 'Error Loading News',
                        onRetryPressed: () => allPostCubit.getPosts(),
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
