class CreateInviteRequest {
  const CreateInviteRequest({this.inviteeId});

  final String? inviteeId;

  Map<String, dynamic> toJson() {
    return {
      ...?(inviteeId == null ? null : {'inviteeId': inviteeId}),
    };
  }
}
