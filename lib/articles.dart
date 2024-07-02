// articles.dart

import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
import 'dart:convert'; // json 사용 위함

class NewsService {
  // 데이터 GET
  Future<List<Article>> fetchArticles(
      // Future - 비동기 메소드 (반환을 후에 해줌) 요청 처리 ((결과가 처리해야 할 함수 지정 역할
      {int page = 1,
      String country = 'us', // kr
      String category = '', // 날짜, 페이지 등 후에 다른 메소드들도 추가해줘야 함
      // String apiKey = 'c2e5f7b1f8ac44619f5776c178c9d5ea'}) async {
      String apiKey = 'd34c82ee45ff40df9fdc2e6c8fce7b80'}) async {
    // 비동기 처리
    String url = 'https://newsapi.org/v2/top-headlines?';
    url += 'country=$country';

    if (category.isNotEmpty && category != 'Headlines') {
      // headline은 없는 카테고리므로
      url += '&category=$category';
    }

    if (page > 1) {
      // 2페이지부터
      url += '&page=$page';
    }

    url += '&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 정상이면
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];

      // 이미지 없어도 출력하도록
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      // 이미지 자료가 있어야만 나옴, 아니면 No Data 나타남
      // List<Article> articles = [];
      // for (var item in body) {
      //   if (await _isUrlValid(item['urlToImage'])) {
      //     articles.add(Article.fromJson(item));
      //   }
      // }
      return articles;
    } else {
      // throw Exception('Failed tp load articles');
      return []; // loading 실패시 빈 리스트 반환하도록 수정 (기존 기사 소실 방지 위함)
    }
  }

  // 유효한 url인지 - 인터넷 방문
  Future<bool> _isUrlValid(String? urlToImage) async {
    try {
      // null 일 때
      if (urlToImage == null || urlToImage.isEmpty) {
        return false;
      }
      final response = await http.head(Uri.parse(urlToImage));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class Article {
  // pure class
  final String title;
  final String description;
  final String? urlToImage;
  final String url;

  Article(
      {required this.title,
      required this.description,
      this.urlToImage, // this.urlToImage,

      required this.url});

  factory Article.fromJson(Map<String, dynamic> json) {
    // factory - single turn class 생성자
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
