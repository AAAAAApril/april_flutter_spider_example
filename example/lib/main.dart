import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/chapter_bean.dart';
import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/fetch_strategy.dart';
import 'package:spider/novel/novel.dart';

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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          ElevatedButton(
            child: const Text('测试爱读书网，获取章节所有段落'),
            onPressed: () async {
              final Novel novel = Novel.loveReading();
              const ChapterPreviewBean chapter = ChapterPreviewBean(
                chapterId: '1',
                chapterName: '第一章 绯红',
              );
              final List<String> paragraphs = await novel.fetchParagraphs(
                strategy: FetchStrategy.networkFirst,
                novelId: '1133',
                chapter: chapter,
              );
              debugPrint('===== BEGIN ===== 诡秘之主 ${chapter.chapterName}');
              for (var element in paragraphs) {
                debugPrint(element);
              }
              debugPrint('====== END ====== 诡秘之主 ${chapter.chapterName}');
            },
          ),
          ElevatedButton(
            child: const Text('测试爱读书网，获取小说详情'),
            onPressed: () async {
              final Novel novel = Novel.loveReading();
              final NovelBean? novelDetail = await novel.novelDetail(
                strategy: FetchStrategy.networkFirst,
                //《诡秘之主》
                novelId: '1133',
              );
              if (novelDetail == null) {
                debugPrint('==== 未获取到小说详情 ====');
                return;
              }
              debugPrint('===== BEGIN ===== 小说详情');
              debugPrint('小说ID：${novelDetail.novelId}');
              debugPrint('小说名：${novelDetail.novelName}');
              debugPrint('作者名：${novelDetail.authorName}');
              debugPrint('分类名：${novelDetail.categoryName}');
              debugPrint('简介：${novelDetail.introduction.length}段');
              for (var element in novelDetail.introduction) {
                debugPrint(element);
              }
              debugPrint('封面：${novelDetail.cover}');
              debugPrint('最后一章：${novelDetail.lastChapter}');
              debugPrint('最后更新时间：${novelDetail.updateTime}');
              debugPrint('小说总章数：${novelDetail.chapters.length}');
              debugPrint('====== END ====== 小说详情');
            },
          ),
          ElevatedButton(
            child: const Text('测试爱读书网，搜索小说'),
            onPressed: () async {
              final Novel novel = Novel.loveReading();
              final List<NovelPreviewBean> novels =
                  await novel.searchNovels(keywords: '余火');
              debugPrint('===== BEGIN ===== 搜索结果');
              for (var element in novels) {
                debugPrint(element.toString());
              }
              debugPrint('====== END ====== 搜索结果');
            },
          ),

          ///测试播放 m3u8 格式视频
          BetterPlayer.network(
            //动漫《诛仙2022》第一季第一集
            'https://new.qqaku.com/20220802/KxFutGmf/index.m3u8',
            betterPlayerConfiguration: const BetterPlayerConfiguration(
              aspectRatio: 16 / 9,
              fit: BoxFit.contain,
            ),
          ),
        ]),
      ),
    );
  }
}
