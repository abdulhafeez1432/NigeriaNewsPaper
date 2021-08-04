import 'package:NewsApp/cubits/category/category_cubit.dart';
import 'package:NewsApp/models/category.dart';
import 'package:NewsApp/repositories/category.dart';
import 'package:NewsApp/sections/search.dart';
import 'package:NewsApp/sections/home.dart';
import 'package:NewsApp/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build_context/build_context.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Josefin",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();

  final categoryCubit = CategoryCubit(categoryRepository: CategoryRepository());

  @override
  void initState() {
    categoryCubit.getCategories();
    super.initState();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: FlatButton(
          onPressed: () {},
          child: Image.asset("assets/images/menu.png"),
        ),
        title: const Center(
          child: Text(
            "NEWS",
            style: TextStyle(
              fontFamily: "Sigmar",
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push(MaterialPageRoute(
              builder: (context) {
                return SearchPost();
              },
            )),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SvgPicture.asset(
                "assets/images/search.svg",
                height: 25,
                width: 25,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                cubit: categoryCubit,
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.white,
                      ),
                    );
                  } else if (state is CategoryFetched) {
                    final categories =
                        [Category(name: 'Home')] + state.categories;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        final category = categories[i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: FlatButton(
                            onPressed: () {
                              _controller.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              Utils.capitalizeFirstLetter(category.name),
                              style: TextStyle(
                                color: currentPage == i
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.categories.length,
                      scrollDirection: Axis.horizontal,
                    );
                  } else if (state is CategoryFetchedError) {
                    return const Center(
                      child: Text('Error Loading Categories'),
                    );
                  }
                  return Container();
                },
              ),
            ),
            BlocBuilder<CategoryCubit, CategoryState>(
              cubit: categoryCubit,
              builder: (context, state) {
                return Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    children: [
                          Section(
                            isNotHomePage: false,
                          ),
                        ] +
                        categoryCubit.categories
                            .map(
                              (e) => Section(
                                categoryName: e.name,
                                isNotHomePage: true,
                              ),
                            )
                            .toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
