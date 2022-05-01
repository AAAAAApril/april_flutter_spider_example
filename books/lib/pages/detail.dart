import 'package:april/widgets/value_listenable_builder.dart';
import 'package:books/viewmodel/detail/detail_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/bqg99/bean/novel.dart';

///书籍详情页
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = ViewModel.of<BookDetailViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: SelectorListenableBuilder<NovelBean?, String>(
          valueListenable: viewModel.bookDetail,
          selector: (value) => value?.name ?? '',
          builder: (_, bookName, __) => Text(bookName),
        ),
        actions: [
          IconButton(
            onPressed: viewModel.refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(children: const [
        _Info(),
        Expanded(child: _Chapters()),
      ]),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO
    return Container();
  }
}

class _Chapters extends StatelessWidget {
  const _Chapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO
    return Container();
  }
}
