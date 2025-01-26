class ValidationUtils {
  /// بررسی صحت آدرس کیف پول
  static bool isValidAddress(String address) {
    final ethereumRegex = RegExp(r'^0x[a-fA-F0-9]{40}$');
    return ethereumRegex.hasMatch(address);
  }

  /// بررسی صحت مقدار وارد شده
  static bool isValidAmount(String amount) {
    final double? value = double.tryParse(amount);
    return value != null && value > 0;
  }
}
