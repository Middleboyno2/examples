import '../entity/notificationEntity.dart';
import '../repository/notificationRepo.dart';

class NotificationUseCase {
  final NotificationRepository _transactionRepository = NotificationRepository();

  Future<bool> addNotification(
      String userId,
      String title,
      String content,
      DateTime time,
      bool status){
    return _transactionRepository.addNotification(userId, title, content, time, status);
  }
  Future<void> setStatusNotification(String notificationId, bool newStatus){
    return _transactionRepository.setStatusNotification(notificationId, newStatus);
  }

  Future<List<NotificationEntity>> getNotificationByUserId(String userId, bool status){
    return _transactionRepository.getNotificationByUserId(userId, status);
  }
  Future<void> updateNotificationsForUser(String userId) async {
    return await _transactionRepository.updateNotificationStatusByTime(userId);
  }

}