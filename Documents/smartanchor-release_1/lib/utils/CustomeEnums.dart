enum UserRoles { ASM, ZSM, NSM, None }

extension on UserRoles {
  String get name {
    switch (this) {
      case UserRoles.ASM:
        return 'ASM';
      case UserRoles.NSM:
        return 'NSM';
      case UserRoles.ZSM:
        return 'ZSM';
      default:
        return "";
    }
  }
}

userRoleFromString(String value) {
  switch (value) {
    case "ASM":
      return UserRoles.ASM;
    case "NSM":
      return UserRoles.NSM;
    case "ZSM":
      return UserRoles.ZSM;
    default:
      return UserRoles.None;
  }
}
