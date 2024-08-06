import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_categories_model.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

final dateFormat = DateFormat("MMMM dd, yyyy");
String selectedValue = "General";
final List<String> categoryList = [
  "General",
  "Entertainment",
  "Sports",
  "Health",
  "Business",
  "Technology",
];

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final newsCategory = NewsViewModel();
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.02, horizontal: width * 0.02),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Icon(Icons.arrow_back_ios_new),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.06,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = categoryList[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedValue == categoryList[index]
                            ? Colors.grey
                            : Colors.green,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        categoryList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: FutureBuilder<NewsCategoriesModel>(
                future: newsCategory.categoriesRepositoryApi(selectedValue),
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
                          padding: const EdgeInsets.all(8.0),
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
                                        Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: GoogleFonts.aBeeZee()
                                                  .fontFamily,
                                              color: Colors.blue),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          dateFormat.format(dateTime),
                                          style: TextStyle(
                                            fontSize: 9.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.aBeeZee()
                                                .fontFamily,
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
            ),
          ],
        ),
      ),
    );
  }
}
