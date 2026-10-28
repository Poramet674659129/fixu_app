enum UserRole { student, technician }

class UserModel {
  final String fullName;
  final String emailOrStudentId;
  final String password;
  final UserRole role;

  UserModel({
    required this.fullName,
    required this.emailOrStudentId,
    required this.password,
    this.role = UserRole.student,
  });

  bool get isTechnician => role == UserRole.technician || emailOrStudentId.contains('@');
}
