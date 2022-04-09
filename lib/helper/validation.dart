String? phoneValidator(String? phone) {
  String patttern = r'(^[0-9]{10}$)';
  RegExp regExp = RegExp(patttern);
  if (phone == null || phone.isEmpty) {
    return 'Số điện thoại không được để trống';
  } else if (phone.length != 10) {
    return 'Số điện thoại phải là 10 số';
  } else if (!regExp.hasMatch(phone)) {
    return 'Số điện thoại không hợp lệ';
  }

  return null;
}

String? passValidator(String? pass) {
  if (pass == null || pass.isEmpty) {
    return 'Mật khẩu không được để trống';
  } else if (pass.length < 6) {
    return 'Mật khẩu chứa tối thiểu 6 ký tự';
  }

  return null;
}

String? emailValidator(String? email) {
  String patttern =
      r'^[a-zA-Z0-9](([.]{1}|[_]{1}|[-]{1}|[+]{1})?[a-zA-Z0-9])*[@]([a-z0-9]+([.]{1}|-)?)*[a-zA-Z0-9]+[.]{1}[a-z]{2,253}$';
  RegExp regExp = RegExp(patttern);
  if (email == null || email.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(email)) {
    return 'Email không hợp lệ';
  }

  return null;
}

String? passportValidator(String? passport) {
  String patttern = r'(^[A-Z]{1}\d{7,8})$';
  RegExp regExp = RegExp(patttern);
  if (passport == null || passport.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(passport)) {
    return 'Số hộ chiếu không hợp lệ';
  }

  return null;
}

String? identityValidator(String? number) {
  String patttern = r'(^[0-9]{9,12}$)';
  RegExp regExp = RegExp(patttern);
  if (number == null || number.isEmpty) {
    return 'Số CMND/CCCD không được để trống';
  } else if (number.length < 9 || number.length > 12) {
    return 'Số CMND/CCCD phải từ 9 - 12 số';
  } else if (!regExp.hasMatch(number)) {
    return 'Số CMND/CCCD không hợp lệ';
  }

  return null;
}

String? quarantineTimeValidator(String? time) {
  String patttern = r'^[0-9]+$';
  RegExp regExp = RegExp(patttern);
  if (time == null || time.isEmpty) {
    return "Trường này là bắt buộc";
  } else if (!regExp.hasMatch(time)) {
    return 'Ngày cách ly không hợp lệ';
  }
  return null;
}

String? numberOfMemberValidator(String? time) {
  String patttern = r'^[0-9]+$';
  RegExp regExp = RegExp(patttern);
  if (time == null || time.isEmpty) {
    return "Trường này là bắt buộc";
  } else if (!regExp.hasMatch(time)) {
    return 'Số người không hợp lệ';
  }
  return null;
}

String? intValidator(String? time) {
  String patttern = r'^[0-9]+$';
  RegExp regExp = RegExp(patttern);
  if (time == null || time.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(time)) {
    return 'Số không hợp lệ';
  }
  return null;
}

String? phoneNullableValidator(String? phone) {
  String patttern = r'(^[0-9]{10}$)';
  RegExp regExp = RegExp(patttern);
  if (phone == null || phone.isEmpty) {
    return null;
  } else if (phone.length != 10) {
    return 'Số điện thoại phải là 10 số';
  } else if (!regExp.hasMatch(phone)) {
    return 'Số điện thoại không hợp lệ';
  }
  return null;
}
