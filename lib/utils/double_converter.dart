import 'package:intl/intl.dart';

double? convertDouble(dynamic e) {
  dynamic result;
  if (e != null) {
    double val = 0.0;
    if (e is String) {
      val = double.parse(e);
    } else if (e is int) {
      val = e.toDouble();
    } else if (e is double) {
      val = e;
    }
    result = num.parse(val.toStringAsPrecision(2)).toDouble();
  } else {
    result = null;
  }
  return result;
}

String convertString<T>(dynamic value) {
  try {
    return (value as String);
  } on TypeError catch (_) {
    return '';
  }
}
