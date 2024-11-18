import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/models/Events.dart';

abstract class HomeView {
  void showLoading();
  void hideLoading();
  void showError();
  void hideError();
  void setButtonActive(String buttonName);
  void setCollectionPoints(List<CollectionPoint> collectionPoints);
  void setEvents(List<Event> events);
}
