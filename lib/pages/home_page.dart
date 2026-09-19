import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/auth_store.dart';
import '../data/testing_catalog.dart';
import '../routes.dart';
import '../widgets/app_bottom_nav.dart';
import 'profile_page.dart';

bool get _isDesktopOrWeb {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const studentName = 'Ильичева Кристина Олеговна';
  static const studentGroup = 'ИКБО-60-23';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          ColoredBox(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: Center(
                  child: Text(
                    TestingCatalog.appTitle,
                    style: const TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: const Color(0xFFEEEEEE),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        TestingCatalog.topicTitle,
                        style: const TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        TestingCatalog.items.map((item) => item.name).join(' · '),
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        TestingCatalog.topicDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 140, child: _HorizontalImages()),
                  const SizedBox(height: 8),
                  const Expanded(child: _TestingItemsView()),
                ],
              ),
            ),
          ),
          ColoredBox(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    ValueListenableBuilder<AppUser?>(
                      valueListenable: AuthStore.session,
                      builder: (_, user, _) => UserAvatar(
                        size: 48,
                        user: user,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<AppUser?>(
                            valueListenable: AuthStore.session,
                            builder: (_, user, _) {
                              return Text(
                                user?.name ?? HomePage.studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Группа ${HomePage.studentGroup}',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _TestingItemsView extends StatelessWidget {
  const _TestingItemsView();

  @override
  Widget build(BuildContext context) {
    final items = TestingCatalog.items;
    final verticalGap = _isDesktopOrWeb ? 16.0 : 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth > 600;
        if (useGrid) {
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(8, 0, 8, verticalGap),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: verticalGap,
              mainAxisExtent: 156,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _TestingTypeCard(item: items[index]);
            },
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(8, 0, 8, verticalGap),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: verticalGap),
          itemBuilder: (context, index) {
            return _TestingTypeCard(item: items[index]);
          },
        );
      },
    );
  }
}

class _TestingTypeCard extends StatelessWidget {
  const _TestingTypeCard({required this.item});

  final TestingType item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(item.iconData, color: Colors.black),
        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          item.shortDescription,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black87),
        ),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail, arguments: item);
        },
      ),
    );
  }
}

class _HorizontalImages extends StatefulWidget {
  const _HorizontalImages();

  @override
  State<_HorizontalImages> createState() => _HorizontalImagesState();
}

class _HorizontalImagesState extends State<_HorizontalImages> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = TestingCatalog.items.map((item) => item.image).toList();
    return Listener(
      onPointerSignal: (event) {
        if (event is! PointerScrollEvent || !_controller.hasClients) return;
        final next =
            (_controller.offset + event.scrollDelta.dy + event.scrollDelta.dx)
                .clamp(
                  _controller.position.minScrollExtent,
                  _controller.position.maxScrollExtent,
                );
        _controller.jumpTo(next);
      },
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                images[index],
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFEEEEEE),
                  child: SizedBox(
                    width: 200,
                    child: Icon(Icons.image_not_supported, color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
