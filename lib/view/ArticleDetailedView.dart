import 'package:ecovitam/models/ArticleDetailed.dart';

abstract class ArticleDetailedView {
  void showLoading();
  void hideLoading();
  void showError();
  void hideError();
  void setArticle(ArticleDetailed article);
}
