String? phoneValidator(String? phone) {
  const String patttern = r'(^[0-9]{10,11}$)';
  final RegExp regExp = RegExp(patttern);
  if (phone == null || phone.isEmpty) {
    return 'Số điện thoại không được để trống';
  } else if (phone.length < 10 || phone.length > 11) {
    return 'Số điện thoại phải là 10-11 số';
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
  const String patttern =
      r'^[a-zA-Z0-9](([.]{1}|[_]{1}|[-]{1}|[+]{1})?[a-zA-Z0-9])*[@]([a-z0-9]+([.]{1}|-)?)*[a-zA-Z0-9]+[.]{1}[a-z]{2,253}$';
  final RegExp regExp = RegExp(patttern);
  if (email == null || email.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(email)) {
    return 'Email không hợp lệ';
  }

  return null;
}

String? passportValidator(String? passport) {
  const String patttern = r'(^[A-Z]{1}\d{7,8})$';
  final RegExp regExp = RegExp(patttern);
  if (passport == null || passport.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(passport)) {
    return 'Số hộ chiếu không hợp lệ';
  }

  return null;
}

String? identityValidator(String? number) {
  const String patttern = r'(^[0-9]{9,12}$)';
  final RegExp regExp = RegExp(patttern);
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
  const String patttern = r'^[0-9]+$';
  final RegExp regExp = RegExp(patttern);
  if (time == null || time.isEmpty) {
    return "Trường này là bắt buộc";
  } else if (!regExp.hasMatch(time)) {
    return 'Ngày cách ly không hợp lệ';
  }
  return null;
}

String? maxNumberValidator(String? num, int maxNum) {
  const String patttern = r'^[0-9]+$';
  final RegExp regExp = RegExp(patttern);
  if (num == null || num.isEmpty) {
    return "Trường này là bắt buộc";
  } else if (!regExp.hasMatch(num)) {
    return 'Số lượng không hợp lệ';
  } else {
    final t = int.parse(num);
    if (t <= 0 || t > maxNum) {
      return "Số lượng phải lớn hơn 0 và nhỏ hơn ${maxNum + 1}";
    }
  }
  return null;
}

String? intValidator(String? num) {
  const String patttern = r'^[0-9]+$';
  final RegExp regExp = RegExp(patttern);
  if (num == null || num.isEmpty) {
    return "Trường này là bắt buộc";
  } else if (!regExp.hasMatch(num)) {
    return 'Số không hợp lệ';
  }
  return null;
}

String? intNullableValidator(String? num) {
  const String patttern = r'^[0-9]+$';
  final RegExp regExp = RegExp(patttern);
  if (num == null || num.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(num)) {
    return 'Số không hợp lệ';
  }
  return null;
}

String? phoneNullableValidator(String? phone) {
  const String patttern = r'(^[0-9]{10}$)';
  final RegExp regExp = RegExp(patttern);
  if (phone == null || phone.isEmpty) {
    return null;
  } else if (phone.length != 10) {
    return 'Số điện thoại phải là 10 số';
  } else if (!regExp.hasMatch(phone)) {
    return 'Số điện thoại không hợp lệ';
  }
  return null;
}

String? userCodeValidator(String? code) {
  const String patttern = r'(^[0-9]{15}$)';
  final RegExp regExp = RegExp(patttern);
  if (code == null || code.isEmpty) {
    return 'Mã người dùng không được để trống';
  } else if (code.length != 15) {
    return 'Mã người dùng không hợp lệ';
  } else if (!regExp.hasMatch(code)) {
    return 'Mã người dùng không hợp lệ';
  }

  return null;
}
