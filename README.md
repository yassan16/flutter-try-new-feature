# 概要
このアプリはFlutterの習熟を目的として、さまざまな機能を実装してみるアプリです。

## 機能一覧
### BottomNavigationBar
go_routerを用いたBottomNavigationBarを実装しています。

#### 参考サイト
* [pub.dev go_router](https://pub.dev/packages/go_router)
* [go_router package Nested navigation](https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html)
* [go_router library StatefulShellRoute](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html)
* [[続] go_routerでBottomNavigationBarの永続化に挑戦する(StatefulShellRoute)](https://zenn.dev/flutteruniv_dev/articles/stateful_shell_route)
* [⭐️サンプルソース Github stateful_shell_route.dart](https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart)

### Stackを用いたWidgetの重複
StackによるWidgetの重複を行うことで、画像に存在するボタンを押しているように見えます。

### 入力フォームリスト
さまざまな入力フォームを一覧で実装しています。

### Flutter Map
Flutter Mapを実際に触って、地図機能を試します。

### GeoLocation
現在地の緯度経度を取得します。
