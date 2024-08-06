import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/new_headline_model.dart';
import 'package:news_app/screens/categories_screen.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../model/news_categories_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, general, entertainment, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  final dateFormat = DateFormat("MMMM dd, yyyy");
  String name = "bbc-news";
  FilterList? selectedMenu;

  @override
  Widget build(BuildContext context) {
    NewsViewModel newsHeadLine = NewsViewModel();
    final newsCategory = NewsViewModel();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "News",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.abel().fontFamily,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            icon: Icon(Icons.category),
          ),
          actions: [
            PopupMenuButton<FilterList>(
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = "bbc-news";
                } else if (FilterList.aryNews.name == item.name) {
                  name = "ary-news";
                } else if (FilterList.general.name == item.name) {
                  name = "abc-news-au";
                } else if (FilterList.entertainment.name == item.name) {
                  name = "entertainment-weekly";
                } else if (FilterList.cnn.name == item.name) {
                  name = "cnn";
                } else if (FilterList.alJazeera.name == item.name) {
                  name = "al-jazeera-english";
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              color: Colors.white,
              icon: Icon(Icons.more_vert_outlined, color: Colors.black),
              initialValue: selectedMenu,
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.bbcNews,
                  child: Text("BBC News"),
                ),
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.aryNews,
                  child: Text("Ary News"),
                ),
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.general,
                  child: Text("General"),
                ),
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.entertainment,
                  child: Text("Entertainment"),
                ),
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.cnn,
                  child: Text("CNN"),
                ),
                PopupMenuItem(
                  height: height * 0.05,
                  value: FilterList.alJazeera,
                  child: Text("Aljazeera"),
                ),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder<NewsHeadLineModel>(
                future: newsHeadLine.newsHeadlineApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Colors.green,
                        size: 24.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null ||
                      snapshot.data!.articles!.isEmpty) {
                    return Center(
                      child: Text('No articles available'),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        final article = snapshot.data!.articles![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.02),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(
                                                  newsImage: snapshot
                                                      .data!
                                                      .articles![index]
                                                      .urlToImage
                                                      .toString(),
                                                  newsTitle: snapshot.data!
                                                      .articles![index].title
                                                      .toString(),
                                                  newsDate: snapshot
                                                      .data!
                                                      .articles![index]
                                                      .publishedAt
                                                      .toString(),
                                                  author: snapshot.data!
                                                      .articles![index].author
                                                      .toString(),
                                                  description: snapshot
                                                      .data!
                                                      .articles![index]
                                                      .description
                                                      .toString(),
                                                  context: snapshot.data!
                                                      .articles![index].content
                                                      .toString(),
                                                  source: snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                )));
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: article.urlToImage ?? '',
                                    placeholder: (context, url) => Center(
                                      child: SpinKitFadingCircle(
                                        color: Colors.green,
                                        size: 24.0,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: Colors.red),
                                    height: height * 0.55,
                                    width: width * 0.8,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(height * 0.016),
                                  width: width * 0.8,
                                  height: height * 0.2,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              GoogleFonts.aBeeZee().fontFamily,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: height * 0.07),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article.source!.name.toString(),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              dateFormat.format(dateTime),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            FutureBuilder<NewsCategoriesModel>(
              future: newsCategory.categoriesRepositoryApi("business"),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitChasingDots(
                      color: Colors.green,
                      size: 24.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text('No articles available'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      final article = snapshot.data!.articles![index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                height: height * 0.2,
                                width: width * 0.4,
                                fit: BoxFit.cover,
                                imageUrl: article.urlToImage ?? '',
                                placeholder: (context, url) => Center(
                                  child: SpinKitFadingCircle(
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: height * 0.07,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.aBeeZee()
                                                .fontFamily,
                                            color: Colors.blue,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        dateFormat.format(dateTime),
                                        style: TextStyle(
                                          fontSize: 9.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              GoogleFonts.aBeeZee().fontFamily,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
