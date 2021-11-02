String? Function(String?) phoneValidator = (phone) {
  if (phone == null || phone.isEmpty) {
    return 'Số điện thoại không được để trống';
  } else if (phone.length != 10) {
    return 'Số điện thoại phải là 10 số';
  }

  return null;
};
