class DuplicatedEmail implements Exception {
  const DuplicatedEmail({this.message = "존재하는 이메일 입니다"});
  final String? message;
}
