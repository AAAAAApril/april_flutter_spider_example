import 'package:april/utils/extensions.dart';
import 'package:april/widgets/value_listenable_builder.dart';
import 'package:books/generated/l10n.dart';
import 'package:books/viewmodel/search/search_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:books/widget/net_work_image.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/bqg99/bean/search.dart';

///搜索页
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = ViewModel.of<SearchViewModel>(context);
    return Column(children: [
      Material(
        elevation: 2,
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: viewModel.editingController,
              maxLines: 1,
              textInputAction: TextInputAction.search,
              onEditingComplete: viewModel.doSearch,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintText: Strings.current.searchHint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                ),
                suffixIcon: SelectorListenableBuilder<TextEditingValue, bool>(
                  valueListenable: viewModel.editingController,
                  selector: (value) => value.text.isNotEmpty,
                  builder: (context, value, child) {
                    if (!value) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: viewModel.clearInput,
                    );
                  },
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: viewModel.doSearch,
          ),
        ]),
      ),
      Expanded(
        child: ValueListenableBuilder<bool>(
          valueListenable: viewModel.isRefreshing,
          child: ValueListenableBuilder<List<SearchResultBean>>(
            valueListenable: viewModel.searchResult,
            builder: (_, value, __) => ListView.separated(
              itemCount: value.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => _Item(bean: value[index]),
            ),
          ),
          builder: (_, refreshing, child) {
            if (refreshing) {
              return const Center(
                child: SizedBox.square(
                  dimension: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return child!;
          },
        ),
      ),
    ]);
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.bean,
  }) : super(key: key);

  final SearchResultBean bean;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ///前往书籍详情
        Navigator.pushNamed(context, 'detail', arguments: bean.id);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///封面
          NetworkImageWidget(bean.cover, width: 80),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///书名
                Text(
                  bean.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ///作者
                Text(Strings.current.author(bean.author)),

                ///类型
                Text(Strings.current.category(bean.category)),

                ///最近章节
                Text.rich(
                  TextSpan(
                    text: Strings.current.latestChapter,
                    children: [
                      TextSpan(
                        text: bean.latestUpdateChapter.name,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ].wrapWithWidget(
                removeFirst: true,
                removeLast: true,
                builder: (length, currentIndex) => const SizedBox(height: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
