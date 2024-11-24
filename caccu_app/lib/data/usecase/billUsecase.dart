import '../entity/billEntity.dart';
import '../repository/billRepo.dart';

class BillUseCase{
  final BillRepository _billRepository = BillRepository();


  Future<bool> addBill2(
      String userId,
      String categoryId,
      String name,
      double price,
      DateTime deadline,
      bool repeat){
    return _billRepository.addBill2(userId, categoryId, name, price, deadline, repeat);
  }
  Future<List<BillEntity>> getBillsByUserAndMonth(String userId, int month){
    return _billRepository.getBillsByUserAndMonth(userId, month);
  }

  Future<bool> deleteBill(String billId){
    return _billRepository.deleteBill(billId);
  }

  Future<bool> updateBill2(
      String billId, // ID of the bill to update
      String userId,
      String categoryId,
      String name,
      double price,
      DateTime deadline,
      bool repeat,
      ){
    return _billRepository.updateBill2(billId, userId, categoryId, name, price, deadline, repeat);
  }
}