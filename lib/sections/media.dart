import 'package:NewsApp/cubits/category/category_cubit.dart';
import 'package:NewsApp/cubits/post/post_cubit.dart';
import 'package:NewsApp/cubits/site/site_cubit.dart';
import 'package:NewsApp/data.dart';
import 'package:NewsApp/details.dart';
import 'package:NewsApp/models/site.dart';
import 'package:NewsApp/networking/api_base_helper.dart';
import 'package:NewsApp/repositories/category.dart';
import 'package:NewsApp/repositories/post.dart';
import 'package:NewsApp/repositories/site.dart';
import 'package:NewsApp/services/utils.dart';
import 'package:NewsApp/widgets/customcachedimage.dart';
import 'package:NewsApp/widgets/empty_result.dart';
import 'package:NewsApp/widgets/error.dart';
import 'package:NewsApp/widgets/site_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:build_context/build_context.dart';

class SpecificSitePost extends StatefulWidget {
  String siteName;

  SpecificSitePost({@required this.siteName});

  @override
  _SpecificSitePostState createState() => _SpecificSitePostState();
}

class _SpecificSitePostState extends State<SpecificSitePost> {
  final allPostCubit = PostCubit(postRepository: PostRepository());
  final siteCubit = SiteCubit(siteRepository: SiteRepository());

  @override
  void initState() {
    allPostCubit.getSitePosts(siteName: widget.siteName);
    siteCubit.getSites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            widget.siteName,
            style: const TextStyle(
              fontFamily: "Sigmar",
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: SvgPicture.asset(
              "assets/images/search.svg",
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
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
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: EmptyResult(
                                  leading:
                                      'Empty ${Utils.capitalizeFirstLetter(widget.siteName)} Feed',
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
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                                                    Icons.book_online_rounded)
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
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
      ),
    );
  }
}
