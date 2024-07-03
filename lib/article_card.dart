// article_card.dart

import 'package:flutter/material.dart';
import 'articles.dart';
import 'package:url_launcher/url_launcher.dart'; // 윈도우 설정 따로 (시스템 사양 차이)
import 'dart:developer' as developer;

class ArticleCard extends StatelessWidget {
  late final Article article;

  ArticleCard({super.key, required this.article}); // 데이터를 외부에서 받아옴

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap 구현 까다로움
      onTap: () => _launchUrl(article
          .url), // developer.log('URL : ${article.url}'), // print 대신 log 이용
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 위에서부터 정렬
          children: [
            (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                ? Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : // 이미지가 구겨지지 않고 적당히 맞춰지도록
                Image.asset('assets/news.jpg'),
            // 이미지가 없으면 대체 이미지
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                article.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                article.description,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
