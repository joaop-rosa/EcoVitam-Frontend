import 'package:ecovitam/models/Article.dart';
import 'package:ecovitam/models/User.dart';

abstract class ArticleView {
  void showLoading();
  void hideLoading();
  void showError();
  void hideError();
  void setArticles(List<Article> articles);
  void setUser(User user);
}
