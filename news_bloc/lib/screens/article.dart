import 'package:flutter/material.dart';
import 'package:news_bloc/models/top_business_news.dart';

class ArticleScreen extends StatelessWidget {
  final Article news;
  const ArticleScreen({
    super.key,
    required this.news,
  });

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
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        height: deviceHeight,
        width: deviceWidth,
        child: ListView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          children: [
            Image.network(
              news.urlToImage ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMxghWKz3Gq_0VKVTyEwzr-t5V9MtXxpQmeA&usqp=CAU',
              errorBuilder: (_, __, ___) {
                return Image.asset(
                  'assets/images/imageError.png',
                  errorBuilder: (_, __, ___) => Container(),
                );
              },
              fit: BoxFit.fill,
              height: isRounded() ? deviceHeight : deviceHeight * 0.4,
              width: deviceWidth * 0.90,
            ),
            ListTile(
              title: Text(
                news.title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
              subtitle: Text(
                news.publishedAt.toString(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              news.content ?? news.description ?? news.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
