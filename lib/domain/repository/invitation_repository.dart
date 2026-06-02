import '../models/paged_result.dart';
import '../models/plan_invitation.dart';

abstract class InvitationRepository {
  Future<PagedResult<PlanInvitation>> listInvitations({
    int limit = 20,
    String? cursor,
  });

  Future<PlanInvitation> getInvitation(String inviteId);

  Future<void> acceptInvitation(String inviteId);

  Future<PlanInvitation> declineInvitation(String inviteId);
}
