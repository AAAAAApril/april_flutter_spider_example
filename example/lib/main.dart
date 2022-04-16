import 'package:flutter/material.dart';
import 'package:spider/log.dart';
import 'package:spider/novel/bqg99/bqg.dart';
import 'package:spider/novel/ouoou/bean/chapter.dart';
import 'package:spider/novel/ouoou/ouoou.dart';
import 'package:spider/platform/bilibili/bilibili.dart';

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
            OuOou.searchNovel('黎明之剑').then((value) {
              for (var element in value) {
                Log.print(tag: '搜索结果', value: () => element);
              }
            });
          },
        ),
        ElevatedButton(
          child: const Text('BiliBili我关注的人的动态列表'),
          onPressed: () {
            BiliBili.followersDynamics().then((value) {
              if (!value.succeed) {
                return;
              }
              Log.print(tag: '分页信息', value: () => value.toString());
              for (var element in value.data) {
                Log.print(
                  tag: '动态：${element.id}',
                  value: () => element.toMap(),
                );
              }
            });
          },
        ),
        ElevatedButton(
          child: const Text('BiliBili检查是否有新动态'),
          onPressed: () {
            BiliBili.checkUpdate(lastDynamicId: '649740153103843337');
          },
        ),
        ElevatedButton(
          child: const Text('笔趣阁搜索《黎明之剑》'),
          onPressed: () {
            Bqg99.searchNovel('黎明之剑').then((value) {
              Log.print(tag: '《黎明之剑》搜索结果');
              for (var element in value) {
                Log.print(value: () => element.toMap());
              }
            });
          },
        ),
        ElevatedButton(
          child: const Text('笔趣阁查询《黎明之剑》详情'),
          onPressed: () {
            Bqg99.novelDetail('1944105').then((value) {
              if (value == null) {
                Log.print(tag: '获取《黎明之剑》详情失败');
                return;
              }
              Log.print(tag: '《黎明之剑》详情', value: () => value.toMap());
            });
          },
        ),
        ElevatedButton(
          child: const Text('笔趣阁获取《黎明之剑》章节《完本感言》详情'),
          onPressed: () {
            Bqg99.chapterDetail(
              novelId: '1944105',
              chapterId: '308697942',
            ).then((value) {
              if (value == null) {
                Log.print(tag: '获取章节详情失败');
                return;
              }
              Log.print(tag: '章节详情', value: () => value.toMap());
              for (var element in value.paragraphs) {
                Log.print(value: () => element);
              }
            });
          },
        ),
      ]),
    );
  }
}
