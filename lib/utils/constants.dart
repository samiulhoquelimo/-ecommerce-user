const String currencySymbol = '৳';

abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
}

enum OrderFilter { TODAY, YESTERDAY, SEVEN_DAYS, THIS_MONTH, ALL_TIME }

Map<String, List<String>> cityArea = {
  'Dhaka': ['Mirpur', 'Dhanmondi', 'Uttara'],
  'Rajshahi': ['Mohonpur', 'Paba', 'Bhaga'],
  'Pabna': ['Sujanogor', 'Bera', 'Ishwardi'],
};
