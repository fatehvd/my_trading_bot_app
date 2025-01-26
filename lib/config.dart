// lib/config.dart

// کلید API مربوط به Moralis
const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImJhNzQ2MjA2LWJhYTItNDUyYy1iN2I5LThkZjlkNzBmNjQwYyIsIm9yZ0lkIjoiNDI1MDg1IiwidXNlcklkIjoiNDM3MjAxIiwidHlwZUlkIjoiZDcyNTA5YzAtYTExMC00MDdjLTkzZTYtZTUzMTNmMGJjM2JlIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MzY1MTMxMTYsImV4cCI6NDg5MjI3MzExNn0.beUIS8na648f7IK6LKyK96YFgl4J4iAMzZwRb01-8qI';

// URL پایه برای درخواست‌های Moralis
const String baseUrl = 'https://deep-index.moralis.io/api/v2.2';

// مسیرهای مختلف API
class ApiEndpoints {
  static String getWalletHistory(String address) => '$baseUrl/wallets/$address/history'; // تاریخچه کیف پول
  static String getERC20TokenBalances(String address) => '$baseUrl/$address/erc20'; // موجودی ERC20
  static String getERC20Transfers(String address) => '$baseUrl/$address/erc20/transfers'; // انتقالات ERC20
  static String getWalletTokens(String address) => '$baseUrl/wallets/$address/tokens'; // توکن‌های کیف پول
  static String getAddressBalance(String address) => '$baseUrl/$address/balance'; // موجودی آدرس
  static String getWalletApprovals(String address) => '$baseUrl/wallets/$address/approvals'; // تاییدیه‌ها
  static String getWalletSwaps(String address) => '$baseUrl/wallets/$address/swaps'; // سواپ‌های کیف پول
  static String getTransactions(String address) => '$baseUrl/wallet/$address/transactions'; // تراکنش‌ها
  static const String sendTransaction = '$baseUrl/transaction/send'; // ارسال تراکنش
}

// پیام‌های خطا
class ErrorMessages {
  static const String networkError = 'Unable to connect to the server. Please check your connection.';
  static const String invalidResponse = 'Received an invalid response from the server.';
  static const String insufficientBalance = 'Insufficient balance for this operation.';
}

// تنظیمات تایم‌اوت برای درخواست‌ها
const Duration apiTimeout = Duration(seconds: 15);

// تنظیمات برای تولید آدرس‌های کیف پول
class WalletDefaults {
  static const String bitcoinPrefix = '00'; // برای بیت‌کوین
  static const String ethereumPrefix = '0x'; // برای اتریوم
}

// آدرس پیش‌فرض کیف پول (مقداردهی با آدرس معتبر)
const String defaultWalletAddress = '0xc97beD9322b669352e5836F4966307C77cF491C5';
