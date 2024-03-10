class CategoriesResponse {
  List<CategoryDataBean>? data;

  CategoriesResponse({this.data});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>)
          .map((dynamic e) => CategoryDataBean.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}

class CategoryDataBean {
  int id;
  String referenceId;
  String name;
  String icon;
  SubCategory? subCategory;

  CategoryDataBean({required this.id, required this.referenceId, required this.name, required this.icon, this.subCategory});

  CategoryDataBean.fromJson(Map<String, dynamic> json) :
        id = json['id'] as int,
        referenceId = json['reference_id'] as String,
        name = json['name'] as String,
        icon = json['icon'] as String,
        subCategory = json['child'] != null ? SubCategory.fromJson(json['child'] as Map<String, dynamic>) : null;
}

class SubCategory {
  List<SubCategoryDataBean>? data;

  SubCategory({this.data});

  SubCategory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>)
          .map((dynamic e) => SubCategoryDataBean.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}

class SubCategoryDataBean {
  int id;
  String referenceId;
  String name;
  String icon;

  SubCategoryDataBean({required this.id, required this.referenceId, required this.name, required this.icon});

  SubCategoryDataBean.fromJson(Map<String, dynamic> json) :
        id = json['id'] as int,
        referenceId = json['reference_id'] as String,
        name = json['name'] as String,
        icon = json['icon'] as String;
}
