import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchTransactions(String accountNumber) async {
  final url = Uri.parse(
    'https://my.sepay.vn/userapi/transactions/list?account_number=$accountNumber&limit=20',
  );

  final headers = {
    'Authorization': 'Bearer BD6JFZE5OW2RCVIE0I3LFCO7V1U1GGOHCWRR5PVJPEUXCNKHYWM8KIPR8X0NLHS7',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['transactions'] != null) {
        print('Transactions: ${data['transactions']}');
      } else {
        print('Ngân hàng này chưa được liên kết.');
        await suggestAddingBank(accountNumber);
      }
    } else if (response.statusCode == 404) {
      print('Ngân hàng này chưa có trong hệ thống.');
      await suggestAddingBank(accountNumber);
    } else {
      print('Failed to load transactions. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Gửi yêu cầu thêm ngân hàng mới
Future<void> suggestAddingBank(String accountNumber) async {
  final url = Uri.parse('https://my.sepay.vn/userapi/banks/suggest');
  final headers = {
    'Authorization': 'Bearer BD6JFZE5OW2RCVIE0I3LFCO7V1U1GGOHCWRR5PVJPEUXCNKHYWM8KIPR8X0NLHS7',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'account_number': accountNumber,
    'message': 'Yêu cầu thêm ngân hàng mới vào hệ thống.',
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Yêu cầu thêm ngân hàng đã được gửi thành công.');
    } else {
      print('Không thể gửi yêu cầu. Mã lỗi: ${response.statusCode}');
    }
  } catch (e) {
    print('Error khi gửi yêu cầu thêm ngân hàng: $e');
  }
}

void main(){
  fetchTransactions('0367504597');
}
