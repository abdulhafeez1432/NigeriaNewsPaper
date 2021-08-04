import 'package:NewsApp/cubits/post/post_cubit.dart';
import 'package:NewsApp/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DetailsScreen extends StatelessWidget {
  final Post post;
  DetailsScreen({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                background: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          stops: const [0.6, 1],
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: "Sigmar",
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    radius: 30,
                                    child: Icon(Icons.person),
                                  ),
                                ),
                                Text(
                                  post.uploaded,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                post.content.replaceAll('\n', '\n'),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Share this Post:",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff4267B2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            "assets/images/facebook.svg",
                            height: 18,
                            color: Colors.white,
                          ),
                          const Text(
                            "Facebook",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            "assets/images/twitter.svg",
                            height: 18,
                            color: Colors.white,
                          ),
                          const Text(
                            "Twitter",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                //   Expanded(
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         gradient: const LinearGradient(
                //           colors: [
                //             Color(0xffFD1D1D),
                //             Color(0xffC13584),
                //           ],
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //         ),
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           SvgPicture.asset(
                //             "assets/images/instagram.svg",
                //             height: 16,
                //             color: Colors.white,
                //           ),
                //           Expanded(
                //             child: const Text(
                //               "Instagram",
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 13,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Share this Post:",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                if (state is PostFetched) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.24,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.postResponse.posts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          final post = state.postResponse.posts[i];
                          return post.imageUrl.isEmpty || post.imageUrl == null
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => DetailsScreen(
                                          post: post,
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
                                            post.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
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
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
