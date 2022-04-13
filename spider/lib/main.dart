import 'package:april_spider/bilibili/bilibili.dart';
import 'package:april_spider/log.dart';
import 'package:april_spider/novel/ouoou/bean/chapter.dart';
import 'package:april_spider/novel/ouoou/ouoou.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Spider Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Wrap(children: <Widget>[
        ElevatedButton(
          child: const Text('Ou中文网，小说分类接口'),
          onPressed: () {
            OuOou.allClassifies().then<void>((value) {
              for (var element in value) {
                Log.print(value: () => element);
              }
            });
          },
        ),
        ElevatedButton(
          child: const Text('Ou中文网，《黎明之剑》详情接口'),
          onPressed: () {
            OuOou.novelDetail('ou_347900').then(
              (value) => Log.print(value: () => value),
            );
          },
        ),
        ElevatedButton(
          child: const Text('Ou中文网，《黎明之剑》第一章详情'),
          onPressed: () {
            OuOou.chapterDetail(
              novelId: 'ou_347900',
              bean: const ChapterBean(
                id: '30237236',
                name: '第一章 穿越成一个视角是什么鬼',
              ),
            ).then(
              (value) => Log.print(value: () => value?.paragraphs),
            );
          },
        ),
        ElevatedButton(
          child: const Text('Ou站内搜索《黎明之剑》'),
          onPressed: () {
            OuOou.searchNovel(keyword: '黎明之剑').then((value) {
              for (var element in value) {
                Log.print(tag: '搜索结果', value: () => element);
              }
            });
          },
        ),
        ElevatedButton(
          child: const Text('BiliBili我关注的人的动态列表'),
          onPressed: () {
            BiliBili.followersDynamics(pageNum: 1);
          },
        ),
      ]),
    );
  }
}
