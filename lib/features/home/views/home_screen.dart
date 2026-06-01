import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/features/features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final ScrollToHideController _hideController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _hideController = ScrollToHideController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = context.select(
      (AuthBloc bloc) => bloc.state.user?.avatarUrl,
    );
    return HomeContainer(
      hideController: _hideController,
      bottomNavBar: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => previous.index != current.index,
        builder: (context, state) {
          return NavigationBar(
            selectedIndex: state.index,
            onDestinationSelected: (value) {
              context.read<HomeCubit>().changeIndex(value);
              _tabController.animateTo(value);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.dynamic_feed_outlined),
                selectedIcon: Icon(Icons.dynamic_feed),
                label: '',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: '',
              ),
              NavigationDestination(
                icon: _AvatarNavIcon(avatarUrl: avatarUrl),
                selectedIcon: _AvatarNavIcon(
                  avatarUrl: avatarUrl,
                  isSelected: true,
                ),
                label: '',
              ),
            ],
          );
        },
      ),
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [FeedScreen(), CalendarScreen(), ProfileScreen()],
      ),
    );
  }
}

class _AvatarNavIcon extends StatelessWidget {
  const _AvatarNavIcon({this.avatarUrl, this.isSelected = false});

  final String? avatarUrl;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    return Container(
      padding: EdgeInsets.all(isSelected ? 2 : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
        child: hasAvatar ? null : const Icon(Icons.person_outline, size: 18),
      ),
    );
  }
}
