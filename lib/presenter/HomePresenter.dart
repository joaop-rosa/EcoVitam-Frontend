import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/models/Events.dart';
import 'package:http/http.dart' as http;
import 'package:ecovitam/view/HomeView.dart';
import 'dart:convert';

class HomePresenter {
  final HomeView view;
  String lastQueryName = '';
  String lastQueryCity = '';

  HomePresenter(this.view);

  Future<void> fetchList(String selectedButtonName) async {
    if (selectedButtonName == 'collectionPoint') {
      await fetchListCollectionPoint();
    } else {
      await fetchListEvents();
    }
  }

  Future<void> fetchListEvents() async {
    view.showLoading();
    view.hideError();

    final Uri url = Uri.parse(
        'http://10.0.2.2:3000/eventos?nome=$lastQueryName&cidade=$lastQueryCity');

    final authToken = await getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        List<Event> eventsResponse = jsonArray.map((jsonItem) {
          return Event.fromJson(jsonItem);
        }).toList();

        view.setEvents(eventsResponse);
      } else {
        view.showError();
      }
    } catch (e) {
      view.showError();
    } finally {
      view.hideLoading();
    }
  }

  Future<void> fetchListCollectionPoint() async {
    view.showLoading();
    view.hideError();

    final Uri url = Uri.parse(
        'http://10.0.2.2:3000/ponto-coleta?nome=$lastQueryName&cidade=$lastQueryCity');

    final authToken = await getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);

        List<CollectionPoint> collectionPointsResponse =
            jsonArray.map((jsonItem) {
          return CollectionPoint.fromJson(jsonItem);
        }).toList();

        view.setCollectionPoints(collectionPointsResponse);
      } else {
        view.showError();
      }
    } catch (e) {
      view.showError();
    } finally {
      view.hideLoading();
    }
  }
}
