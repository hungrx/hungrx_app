class FormValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // static String? validatePhone(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Phone number is required';
  //   }
  //   if (value.length != 10) {
  //     return 'Phone number must be 10 digits';
  //   }
  //   if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
  //     return 'Phone number must contain only digits';
  //   }
  //   return null;
  // }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 18 || age > 100) {
      return 'Age must be between 13 and 100';
    }
    return null;
  }

  static String? validateHeight(String? value, bool isMetric) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }
    if (isMetric) {
      if (height < 100 || height > 250) {
        return 'Height must be between 100cm and 250cm';
      }
    } else {
      // For feet
      if (height < 3 || height > 8) {
        return 'Height must be between 3 and 8 feet';
      }
    }
    return null;
  }

  static String? validateHeightInches(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inches is required';
    }
    final inches = double.tryParse(value);
    if (inches == null) {
      return 'Please enter valid inches';
    }
    if (inches < 0 || inches >= 12) {
      return 'Inches must be between 0 and 11';
    }
    return null;
  }
}