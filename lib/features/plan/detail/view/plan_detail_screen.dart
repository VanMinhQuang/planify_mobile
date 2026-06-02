import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/view/tabs/activity_tab.dart';
import 'package:planify_mobile/features/plan/detail/view/tabs/notes_tab.dart';
import 'package:planify_mobile/features/plan/detail/view/tabs/overview_tab.dart';
import 'package:planify_mobile/features/plan/detail/view/tabs/task_tab.dart';
import 'package:planify_mobile/features/plan/detail/widgets/modal/friend_modal.dart';
import 'package:share_plus/share_plus.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _noteController = TextEditingController();
  late PlanDetailCubit bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    bloc = context.read<PlanDetailCubit>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanDetailCubit, PlanDetailState>(
      listenWhen: (previous, current) =>
          previous.inviteUrl != current.inviteUrl ||
          previous.message != current.message,
      listener: (context, state) {
        final inviteUrl = state.inviteUrl;
        if (inviteUrl != null) {
          SharePlus.instance.share(ShareParams(text: inviteUrl));
        }
        final message = state.message;
        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final plan = state.plan;
        final currentUserId = context.select(
          (AuthBloc bloc) => bloc.state.user?.id,
        );
        final canViewMemberContent = state.canViewMemberContent(currentUserId);
        return AppContainer(
          isFullScreen: true,
          appBarTitle: plan?.title ?? 'Plan',
          iconRight: IconButton(
            tooltip: 'Invite',
            onPressed:
                plan == null || !canViewMemberContent || state.isCreatingInvite
                ? null
                : () => _showInviteSheet(context, state),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : canViewMemberContent
              ? Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Tasks'),
                        Tab(text: 'Notes'),
                        Tab(text: 'Activity'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OverviewTab(state: state),
                          const TasksTab(),
                          NotesTab(controller: _noteController),
                          ActivityTab(state: state),
                        ],
                      ),
                    ),
                  ],
                )
              : OverviewTab(state: state),
        );
      },
    );
  }

  Future<void> _showInviteSheet(
    BuildContext context,
    PlanDetailState state,
  ) async {
    if (state.friends.isEmpty && !state.isLoadingFriends) {
      bloc.refreshFriends();
    }

    await SheetUtils.openCustomBottomSheet(
      context: context,
      builder: (sheetContext) {
        return FriendModal(bloc: bloc);
      },
    );
  }
}
