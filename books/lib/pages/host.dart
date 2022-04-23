import 'package:books/generated/l10n.dart';
import 'package:books/pages/search.dart';
import 'package:books/pages/settings.dart';
import 'package:books/pages/shelf.dart';
import 'package:flutter/material.dart';

///主界面
class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final List<_MainConfig> configs = <_MainConfig>[
    _MainConfig(
      title: (context) => Strings.current.bookShelf,
      icon: Icons.book_rounded,
      page: (context) => const BookShelfPage(),
    ),
    _MainConfig(
      title: (context) => Strings.current.search,
      icon: Icons.search_rounded,
      page: (context) => const SearchPage(),
    ),
    _MainConfig(
      title: (context) => Strings.current.settings,
      icon: Icons.settings_rounded,
      page: (context) => const SettingsPage(),
    ),
  ];

  late ValueNotifier<int> selected;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    selected = ValueNotifier<int>(0);
    controller = PageController(initialPage: selected.value);
  }

  @override
  void dispose() {
    controller.dispose();
    selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: selected,
          builder: (_, index, __) => Text(
            configs[index].title.call(context),
          ),
        ),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: configs.length,
        onPageChanged: (index) {
          selected.value = index;
        },
        itemBuilder: (_, index) => configs[index].page.call(context),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selected,
        builder: (_, index, __) => BottomNavigationBar(
          currentIndex: index,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
          items: configs
              .map<BottomNavigationBarItem>(
                (e) => BottomNavigationBarItem(
                  label: e.title.call(context),
                  icon: Icon(e.icon),
                ),
              )
              .toList(),
          onTap: (index) {
            selected.value = index;
          },
        ),
      ),
    );
  }
}

class _MainConfig {
  const _MainConfig({
    required this.title,
    required this.icon,
    required this.page,
  });

  final String Function(BuildContext context) title;
  final IconData icon;
  final WidgetBuilder page;
}
