import 'package:get/get.dart';

validateUsername(String value) {
  if (value.isEmpty) {
    return 'Enter user name.';
  }
  if (value.length < 3 || value.length > 20) {
    return 'Username must be between 3 and 20 characters long.';
  }
  if (!RegExp(r'^[ a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Username can only contain letters, numbers, and underscores.';
  }
  return null;
}

isTitle(String value) {
  if (value.isEmpty) {
    return 'Enter Title.';
  }
  return null;
}

isDuration(String value) {
  if (value.isEmpty) {
    return 'Enter Duration.';
  }
  return null;
}

isGlass(String value) {
  if (value.isEmpty) {
    return 'Enter Glass.';
  }
  return null;
}

isUserNameValid(String value) {
  if (value.isEmpty) {
    return 'Enter your username.';
  }
  return null;
}

isEmailValid(String value) {
  if (value.isEmpty) {
    return 'Enter your email.';
  } else if (!GetUtils.isEmail(value)) {
    return 'Enter valid email.';
  }
  return null;
}

isAmountValid(String value) {
  if (value.isEmpty) {
    return 'Enter your amount.';
  } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
    return 'Enter valid amount';
  } else if (double.parse(value) == 0) {
    return 'Amount cannot be zero.';
  }
  return null;
}

isPhoneNumberValid(String value) {
  if (value.isEmpty) {
    return 'Enter your phone number.';
  } else if (value.length < 8) {
    return 'Enter a valid phone number.';
  }
  return null;
}

isPasswordValid(String value) {
  if (value.isEmpty) {
    return 'Please enter a password.';
  }
  if (value.length < 8) {
    return 'Password must be 8 length: ${value.length} /8';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter.';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter.';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number.';
  }
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character.';
  }
  return null;
}

// validateDOB(String? value) {
//   if (value == null || value.isEmpty) {
//     return 'Please enter your date of birth';
//   }
//   try {
//     DateTime dob = DateFormat('dd-MM-yyyy').parseStrict(value);
//     int age = calculateAge(dob);
//     if (age < 17) {
//       return 'Age under 17 is not accepted';
//     } else if (age > 90) {
//       return 'Age above 90 is not accepted';
//     }
//   } catch (e) {
//     return 'Invalid date format';
//   }
//   return null;
// }

int calculateAge(DateTime dob) {
  DateTime today = DateTime.now();
  int age = today.year - dob.year;
  if (today.month < dob.month ||
      (today.month == dob.month && today.day < dob.day)) {
    age--;
  }
  return age;
}

isConfirmPassword(String value, String password) {
  if (value.isEmpty) {
    return 'Retype your password.';
  } else if (password.isEmpty) {
    return 'Enter your password first.';
  } else if (value != password) {
    return "Your password don't match.";
  }
  return null;
}

isPinputValid(String value) {
  if (value.isEmpty) {
    return 'Enter the code.';
  } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
    return 'The code must be of 6 digits number.';
  }
  return null;
}
