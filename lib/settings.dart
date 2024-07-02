import 'package:flutter/material.dart';
import '';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>(); // 유효 확인

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            // const [
            Icon(
              Icons.settings,
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
