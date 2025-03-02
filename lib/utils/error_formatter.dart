class ErrorFormatter {
  static String formatError(dynamic e) {
    final message = e.toString();

    // Special case handling
    if (message.contains('internet')) {
      return 'Please check your internet connection';
    } else if (message.contains('timed out')) {
      return 'The request took too long. Try again';
    } else if (message.contains("API URL")) {
      return "Please set API URL in Settings";
    } else if (message.contains("Invalid response")) {
      return "Invalid response returned by API";
    } else {
      return message;
    }
  }
}
