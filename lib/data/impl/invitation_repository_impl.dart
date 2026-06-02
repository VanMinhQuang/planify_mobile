import '../../domain/models/paged_result.dart';
import '../../domain/models/plan_invitation.dart';
import '../../domain/repository/invitation_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/plan_invitation_dto.dart';

class InvitationRepositoryImpl implements InvitationRepository {
  InvitationRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<PagedResult<PlanInvitation>> listInvitations({
    int limit = 20,
    String? cursor,
  }) async {
    final result = await _apiClient.get(
      path: ApiUrl.invitations,
      queryParameters: {
        'limit': limit,
        ...?(cursor == null ? null : {'cursor': cursor}),
      },
      parser: (json) => PagedResult.fromJson(
        json,
        (item) => PlanInvitationDto.fromJson(item).toDomain(),
      ),
    );

    return result ??
        const PagedResult(
          items: [],
          nextCursor: null,
          hasNextPage: false,
          totalCount: 0,
        );
  }

  @override
  Future<PlanInvitation> getInvitation(String inviteId) async {
    final result = await _apiClient.get(
      path: ApiUrl.invitation(inviteId),
      parser: (json) =>
          PlanInvitationDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    return result ??
        const PlanInvitation(
          id: '',
          code: '',
          planId: '',
          createdBy: '',
          status: 'PENDING',
          role: 'EDITOR',
          createdAt: null,
        );
  }

  @override
  Future<void> acceptInvitation(String inviteId) async {
    await _apiClient.post(
      path: ApiUrl.acceptInvitation(inviteId),
      body: {},
      parser: (_) => null,
    );
  }

  @override
  Future<PlanInvitation> declineInvitation(String inviteId) async {
    final result = await _apiClient.post(
      path: ApiUrl.declineInvitation(inviteId),
      body: {},
      parser: (json) =>
          PlanInvitationDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    return result ??
        const PlanInvitation(
          id: '',
          code: '',
          planId: '',
          createdBy: '',
          status: 'DECLINED',
          role: 'EDITOR',
          createdAt: null,
        );
  }
}
