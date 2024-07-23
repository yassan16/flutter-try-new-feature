import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_try_new_feature/constant/const_setting.dart';

// 実装中
class InputFormListPage extends StatefulWidget {
  const InputFormListPage({super.key});

  @override
  State<InputFormListPage> createState() => _InputFormListPageState();
}

class _InputFormListPageState extends State<InputFormListPage> {
  late TextEditingController _textEditingcontroller;

  // 入力したテキスト
  String _inputText = "未入力";
  // 選択したセグメント
  String _segment = "1";
  // 選択した日時
  String _selectedDateTime = "";


  @override
  void initState() {
    super.initState();
    _textEditingcontroller = TextEditingController();
  }

  @override
  void dispose() {
    // メモリリークを防ぐため
    _textEditingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '入力フォームリスト',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Row(children: [
        // 左側の余白
        spacerSizedBox(),

        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(top: 20),
          child: Column(children: [
            makeTextFormField(),
            makeDivider(),
            slidingSegmented(),
            makeDivider(),
            drumRollDateTime(),
            makeDivider(),
          ],),
        ),

        // 右側の余白
        spacerSizedBox(),
      ],),
    );
  }

  /// 両サイドの余白
  Widget spacerSizedBox(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.05,
    );
  }

  /// 区切り線
  Widget makeDivider(){
    return
      Divider(
        // 区切り線上下の空白
        height: 100,
        // 区切り線の太さ
        thickness: 3,
      );
  }

  /// TextFormFieldの作成
  ///
  /// TextFieldとの違いは、validaorを持っていることと、Form widgetによる一括バリデーションの実行可否
  Widget makeTextFormField(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベル
          Container(
            child: Text("テキストフィールド"),
          ),
          // 入力フォーム
          TextFormField(
            controller: _textEditingcontroller,
            onChanged: (value) {
              setState(() {
                _inputText = value;
                // controllerから取得も可能
                // _inputText = _textEditingcontroller.text;
              });
            },
            validator: (value) {
              if(value == null || value.isEmpty){
                return "値を入力してください！";
              }
              if(value.length < 3){
                return "3文字以上入力してください！";
              }
              // 問題なし
              return null;
            },
            // 入力時に自動バリデーション
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // 右下にカウンターも表示される
            maxLength: 10,
            style: TextStyle(
              fontSize: ConstSetting.settingFontSize,
            ),
            decoration: InputDecoration(
              hintText: "ヒント文字",
              border: OutlineInputBorder(
                // 枠線の丸み
                borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                // 入力時の枠線
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          // 入力した文字の確認
          Container(
            child: Text("入力結果： ${_inputText}"),
            margin: EdgeInsets.only(top: 20),
          ),
      ],)
    );
  }

  /// スライドセグメント
  Widget slidingSegmented(){
    // Containerのサイズを親ウェジェットのサイズとの比率で設定
    return FractionallySizedBox(
      widthFactor: 1,
      // color: Colors.red,
      child: CupertinoSlidingSegmentedControl(
        groupValue: _segment,
        onValueChanged: (value) {
          setState(() {
            _segment = value!;
          });
        },
        children: {
          for (final segment in ["1", "2", "3"])
            segment: Container(
              height: 40,
              // 文字を中央に配置
              alignment: Alignment.center,
              child: Text(
                segment,
                style: TextStyle(
                  fontSize: ConstSetting.settingFontSize,
                ),),
            ),
        },
      ),
    );
  }

  /// ドラムロールでの日時選択
  Widget drumRollDateTime(){

    DateTime nowDateTime = DateTime.now();

    return
      Container(
        child: Column(
          children: [
            // 選択した日時
            Text(_selectedDateTime),
            // 選択ボタン
            TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                  // キャンセル・完了ボタンの表示
                  showTitleActions: true,
                  minTime: DateTime(nowDateTime.year, nowDateTime.month -1, nowDateTime.day),
                  maxTime: DateTime(nowDateTime.year, nowDateTime.month +1, nowDateTime.day),
                  onChanged: (date) {
                    print("=====変更中=====");
                    print(date);
                  },
                  onConfirm: (date) {
                    setState(() {
                      // フォーマットを変更して表示
                      _selectedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
                    });
                    print("=====完了=====");
                    print(_selectedDateTime);
                  },
                  // 初期値
                  currentTime: nowDateTime,
                  locale: LocaleType.jp
                );
              },
              child: const Text(
                '日付+時間を選択',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );

  }
}
