// 뉴스 어플리케이션 만들기

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/article_card.dart';
import 'articles.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<StatefulWidget> createState() =>
      _NewsPageState(); // 상태를 만들어야 함, _NewsPageState가 실체
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> futureArticles; // 받는 임시 리스트
  final List<Article> _articles = []; // 최종 출력 리스트
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _country = 'us';
  String _category = '';
  bool _isLoadingMore = false;

  // ListTile 없애기
  // String, Dynamic으로 leading Icon을 같이 설정해주려 했으나
  // IconData 값을 알맞게 읽지 못하여 불가피하게 List Map을 하나 더 생성
  final List<Map<String, String>> categories = [
    {'title': 'Headlines'},
    {'title': 'Business'},
    {'title': 'Technology'},
    {'title': 'Entertainment'},
    {'title': 'Sports'},
    {'title': 'Science'},
    {'title': 'Health'},
  ];
  final List<IconData> categoriesIcon = [
    Icons.label,
    Icons.business,
    Icons.computer,
    Icons.movie,
    Icons.directions_bike,
    Icons.science,
    Icons.health_and_safety,
  ];

  @override // 이곳에 데이터 로딩 처리
  void initState() {
    super.initState();
    futureArticles = NewsService().fetchArticles();
    futureArticles.then((articles) {
      setState(() => _articles.addAll(articles));
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 아래 코드 보며 수정해보기
  void _onCountryTap({String country = 'us'}) {
    setState(() {
      // 기사 clear 해줘야 함
      _articles.clear();
      _currentPage = 1;
      futureArticles = NewsService().fetchArticles(
          country: country, category: _category); // current 카테고리로
      futureArticles.then((articles) {
        setState(() => _articles.addAll(articles));
        //
        _country = country;
      });
    });
  }

  // drawer 내 카테고리 메뉴 탭 시 기능 함수
  void _onCategoryTap({String category = ''}) {
    setState(() {
      // 기사 clear 해줘야 함
      _articles.clear();
      _currentPage = 1;
      futureArticles = NewsService().fetchArticles(
          category: category, country: _country); //current country로
      futureArticles.then((articles) {
        setState(() => _articles.addAll(articles));
        _category = category;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 나라에 따른 하단 Country 사진 지정
    String countryImage = 'assets/us.webp';
    String countryName = 'Country';

    if (_country == 'us') {
      countryImage = 'assets/us.webp';
      countryName = 'United State';
    } else if (_country == 'kr') {
      countryImage = 'assets/kr.png';
      countryName = 'Korea';
    } else if (_country == 'jp') {
      countryImage = 'assets/jp.png';
      countryName = 'Japan';
    } else if (_country == 'gr') {
      countryImage = 'assets/gr.jpg';
      countryName = 'Greece';
    } else if (_country == 'cn') {
      countryImage = 'assets/cn.png';
      countryName = 'China';
    } else if (_country == 'fr') {
      countryImage = 'assets/fr.png';
      countryName = 'France';
    } else if (_country == 'ar') {
      countryImage = 'assets/ar.png';
      countryName = 'Argentina';
    } else if (_country == 'br') {
      countryImage = 'assets/br.png';
      countryName = 'Brazil';
    }

    // 호출되어지는 부분
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today News',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic),
        ), // style: TextStyle(color: Theme.of(context).textTheme)),
        backgroundColor:
            Theme.of(context).colorScheme.primary, // .inverseSurface,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              // const
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/news.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: // Stack(
                  // children: [
                  //   Positioned.fill(
                  //     child: BackdropFilter(
                  //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  //       child: Container(
                  //         color: Colors.white.withOpacity(0.1),
                  //       ),
                  //     ),
                  //   ),
                  Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 100)),
                  Text(
                    'News Categories',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              // ],
              // ),
            ),

            // ListTile 정리 (6개 붙인 거 간단히)
            // ...categories.map((category) => ListTile(
            //     title: Text(
            //       category['title']!,
            //       style: const TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     onTap: () {
            //       _onCategoryTap(category: category['title']!);
            //       Navigator.pop(context);
            //     })),
            ...List.generate(categories.length, (index) {
              return ListTile(
                leading: Icon(categoriesIcon[index]),
                title: Text(
                  categories[index]['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  _onCategoryTap(category: categories[index]['title']!);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      // 받아야 할 데이터 형태
      body: FutureBuilder<List<Article>>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 스냅샷 상태 대기
              return const Center(child: CircularProgressIndicator()); // 대기 아이콘
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            } else {
              return ListView.builder(
                // error 가능성 부분
                controller: _scrollController,

                itemCount: _articles.length +
                    (_isLoadingMore ? 1 : 0), // snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (index == _articles.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final article = _articles[index]; // snapshot.data![index];
                  return ArticleCard(
                    article: article,
                    key: ValueKey(article.title),
                  ); // key값 만들어줌
                },
              );
            }
          }), // snapshot이 데이터
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                countryImage,
                width: 50,
                height: 30,
              ),
              // icon: Icon(Icons.public),
              label: '$countryName'), // 'Country'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: ((value) => _onNavItemTap(value, context)),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200 && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      // 스크롤 내리면 데이터 더 로딩
      _loadMoreArticles();
    }
  }

  Future<void> _loadMoreArticles() async {
    // 언제 실행될지 모르는 비동기 async
    _currentPage++;
    List<Article> articles = await NewsService().fetchArticles(
        page: _currentPage, category: _category, country: _country);
    // 바뀌었으면
    setState(() {
      _articles.addAll(articles); // 누적
      _isLoadingMore = false; // 더이상 스크롤 내려도 변화 없도록 false
      // country 현재 나라로 유지되도록 수정 !!
    });
  }

  // country 탭이 눌렸을 때
  void _showModalBottomSheet(BuildContext context) {
    // ListTile 고쳤던 것처럼 county 탭 3개
    List<Map<String, String>> items = [
      {'title': 'USA', 'image': 'assets/us.webp', 'code': 'us'},
      {'title': 'KOREA', 'image': 'assets/kr.png', 'code': 'kr'},
      {'title': 'JAPAN', 'image': 'assets/jp.png', 'code': 'jp'},
      {'title': 'CHINA', 'image': 'assets/cn.png', 'code': 'cn'},
      {'title': 'GREECE', 'image': 'assets/gr.jpg', 'code': 'gr'},
      {'title': 'FRANCE', 'image': 'assets/fr.png', 'code': 'fr'},
      {'title': 'ARGENTINA', 'image': 'assets/ar.png', 'code': 'ar'},
      {'title': 'BRAZIL', 'image': 'assets/br.png', 'code': 'br'},
    ];

// 001 159

    showModalBottomSheet(
        context: context, // showModal.. 빈 캔버스
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            color: Colors.white,
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 50.0,
              mainAxisSpacing: 30.0,
              children: [
                // Container 간단히 List 붙여서 나타내기
                ...List.generate(items.length, (index) {
                  return Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _onCountryTap(country: items[index]['code']!);
                      },
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            items[index]['image']!,
                            width: 50,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            items[index]['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                    ),
                  );
                })
              ],
            ),
          );
        });
  }

  _onNavItemTap(int value, BuildContext context) {
    // value : 3개 아이템 중 무엇이 눌렸는지
    print('Selected Index: $value');

    switch (value) {
      case 0: // country 탭을 눌렀을 때
        _showModalBottomSheet(context);
        break;
      case 1:
        // Search
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
  }
}
