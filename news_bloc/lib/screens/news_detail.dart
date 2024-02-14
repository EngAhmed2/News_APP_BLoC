import 'package:flutter/material.dart';
import 'package:news/models/top_business_news.dart';

class NewsDetail extends StatelessWidget {
  final Article news;
  const NewsDetail({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    bool isRounded() {
      if (MediaQuery.of(context).size.height < 450) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: isRounded()
                ? deviceHeight * 0.40
                : deviceWidth,
            width: deviceWidth * 0.90,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Image.network(
                news.urlToImage ??
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMxghWKz3Gq_0VKVTyEwzr-t5V9MtXxpQmeA&usqp=CAU',
                fit: BoxFit.fill),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 500 ? 40 : 12),
              child: ListView(
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  Text(
                    news.publishedAt.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey),
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    news.content ??
                        news.description ??
                        "This news have only title!!",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
