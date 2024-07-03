// settings.dart

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>(); // 유효 확인

  bool _obscureText = true;
  double _sliderValue = 0;
  bool checked = false;
  bool switchValue = false;
  String email = ''; // 여기에 이메일 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            // const [
            Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Scrollbar(
            // 키보드 뜰 때
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    // 영역 자동 계산
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...[
                          // 리스트에 리스트 추가 연산자
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Enter your ID',
                              labelText: 'ID',
                            ),
                            onChanged: (value) {
                              print(value);
                            }, // 상태값 받아오기
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              // InputDeco 앞 const 삭제
                              icon: Icon(Icons.lock),
                              hintText: 'Enter your Password',
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off), //
                                onPressed: () {
                                  setState(() {
                                    // 강제 갱신 -> obscureText가 바뀜
                                    _obscureText = !_obscureText; // 반전 toggle
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText, // 비밀번호 필드가 됨
                            onChanged: (value) {
                              print(value);
                            }, // 상태값 받아오기
                          ),
                          TextFormField(
                            // 멀티 라인
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              icon: Icon(Icons.email),
                              hintText: 'Enter your Email',
                              labelText: 'Email',
                            ),
                            maxLength: 300, // 글자수 제한
                            maxLines: 5, // 줄 제한
                            onChanged: (value) {
                              email = value; // setState X, 이미 처리값이 보이는 상태므로
                            }, // 들어오는 value에 따른 함수 처리
                          ),
                          Column(
                            // 슬라이드 바 구현
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // 옆으로 내용 추가 가능
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // 적당한 비율로 분배
                                children: [
                                  Text(
                                    '슬라이드바',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Text('${_sliderValue.toInt()}'),

                              ///500'),
                              Slider(
                                min: 0,
                                max: 500,
                                divisions: 500,
                                value: _sliderValue,
                                onChanged: (value) {
                                  setState(() {
                                    // 상태 변경 알려주는 함수
                                    _sliderValue = value; // 현재 슬라이더 값 변경
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // start : css의 플렉스, 가로축 앞에서부터 채워나감
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // 세로방향
                            children: [
                              Checkbox(
                                value: checked,
                                onChanged: (value) {
                                  setState(() {
                                    checked = value!; // 아래에 또 표시하기 위해
                                  });
                                },
                              ),
                              Text((checked)
                                  ? '체크됨'
                                  : '체크안됨'), // 체크 상태 업데이트를 위해 setState 추가
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Switch(
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value!;
                                  });
                                },
                              ),
                              Text((switchValue) ? '켜짐' : '꺼짐'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
