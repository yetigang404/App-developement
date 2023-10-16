import 'package:json_annotation/json_annotation.dart';

part 'invitation.g.dart';

@JsonSerializable()
class Invitation {
  String household; // household id
  String sender; // sender uid
  String reciever; // reciever uid
  String status; // "pending" | "accepted" | "declined";
  Invitation(this.household, this.sender, this.reciever, this.status);

  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}
