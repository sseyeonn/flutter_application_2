// search.dart

import 'package:flutter/material.dart';
import 'article_card.dart';
import 'articles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>(); // 유효 확인
  final TextEditingController _searchController = TextEditingController();

  List<Article> _articles = []; // 전체 기사 리스트
  List<Article> _filteredArticles = []; // 검색된 기사 리스트

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose(); // 상태가 없어지기 전에 호출
  }

  void _loadArticles() async {
    List<Article> articles = await NewsService().fetchArticles(); // 기사 가져오기
    setState(() {
      _articles = articles; // 전체 기사 리스트에 가져온 기사 리스트 넣기
      _filteredArticles = articles; // 검색된 기사 리스트에 전체 기사 리스트 넣기
    });
  }

  void _onSearchChanged() {
    String query =
        _searchController.text.toLowerCase(); // 검색어 소문자로 변환 -> 대소문자 구분 없애기
    setState(() {
      _filteredArticles = _articles
          .where((article) => article.title.toLowerCase().contains(query))
          .toList(); // 검색된 기사 리스트에 검색어가 포함된 기사 리스트 넣기
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            // 키보드 뜰 때
            children: [
              // 리스트에 리스트 추가 연산자
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_outlined),
                  hintText: 'Search your interest',
                  labelText: 'Search',
                ),
                onChanged: (value) {
                  // 검색어 입력 시
                  print(value);
                }, // 상태값 받아오기
              ),
              const SizedBox(height: 20),
              Expanded(
                // 화면 크기에 맞게 확장
                child: _filteredArticles.isEmpty
                    ? const Center(child: Text('No articles found'))
                    : ListView.builder(
                        itemCount: _filteredArticles.length, // 검색된 기사 리스트의 길이만큼
                        itemBuilder: (context, index) {
                          // 기사 카드 생성
                          return ArticleCard(
                            article: _filteredArticles[
                                index], // 검색된 기사 리스트의 index번째 기사
                            key: ValueKey(_filteredArticles[index]
                                .title), // 기사 제목으로 key 생성
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
