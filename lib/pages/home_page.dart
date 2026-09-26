import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../data/auth_store.dart';
import '../data/testing_data.dart';
import '../di/injection.dart';
import '../models/testing_type.dart';
import '../routes.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/theme_mode_button.dart';
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
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(LoadHomeEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeError) {
            return _HomeStatus(message: state.message);
          }
          if (state is! HomeLoaded) {
            return const _HomeStatus();
          }
          return _HomeView(items: state.items);
        },
      ),
    );
  }
}

class _HomeStatus extends StatelessWidget {
  const _HomeStatus({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: message == null
            ? const CircularProgressIndicator()
            : Text(message!),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.items});

  final List<TestingType> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          ColoredBox(
            color:
                theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      appTitle,
                      style: const TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 26,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: ThemeModeButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        topicTitle,
                        style: const TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        items.map((item) => item.name).join(' · '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _InfoBox(
                      child: Text(
                        topicDescription,
                        style: const TextStyle(fontSize: 14, height: 1.35),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: _HorizontalImages(
                      images: items.map((item) => item.image).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: _TestingItemsView(items: items)),
                ],
              ),
            ),
          ),
          ColoredBox(
            color:
                theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
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
                      builder: (_, user, _) => UserAvatar(size: 48, user: user),
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
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Группа ${HomePage.studentGroup}',
                            style: TextStyle(fontSize: 13),
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
  const _TestingItemsView({required this.items});

  final List<TestingType> items;

  @override
  Widget build(BuildContext context) {
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
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(item.iconData),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item.shortDescription,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail, arguments: item);
        },
      ),
    );
  }
}

class _HorizontalImages extends StatefulWidget {
  const _HorizontalImages({required this.images});

  final List<String> images;

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
    final images = widget.images;
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
                errorBuilder: (_, _, _) => ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const SizedBox(
                    width: 200,
                    child: Icon(Icons.image_not_supported),
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
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
