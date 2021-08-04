import 'package:NewsApp/models/site.dart';
import 'package:NewsApp/networking/api_base_helper.dart';
import 'package:NewsApp/sections/media.dart';
import 'package:NewsApp/services/utils.dart';
import 'package:NewsApp/widgets/customcachedimage.dart';
import 'package:flutter/material.dart';
import 'package:build_context/build_context.dart';

class SitesListView extends StatelessWidget {
  final List<Site> sites;

  const SitesListView({Key key, @required this.sites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sites.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: sites.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              final site = sites[i];
              return Container(
                margin: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SpecificSitePost(siteName: site.name);
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[300]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomCachedNetworkImage(
                            imageUrl: 'https://' +
                                ApiBaseHelper.getBaseURL() +
                                site.logo,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: Text(
                          Utils.capitalizeFirstLetter(site.name),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
