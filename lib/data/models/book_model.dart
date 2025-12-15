/*
 * Book model scaffolded via https://app.quicktype.io/ using data from https://bukuacak.vercel.app/api
 */

class Book {
  String id;
  String title;
  String coverImage;
  NameUrl author;
  NameUrl category;
  String summary;
  BookDetails details;
  List<NameUrl> tags;
  List<BuyLink> buyLinks;
  String publisher;

  Book({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.author,
    required this.category,
    required this.summary,
    required this.details,
    required this.tags,
    required this.buyLinks,
    required this.publisher,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["_id"],
    title: json["title"],
    coverImage: json["cover_image"],
    author: NameUrl.fromJson(json["author"]),
    category: NameUrl.fromJson(json["category"]),
    summary: json["summary"],
    details: BookDetails.fromJson(json["details"]),
    tags: List<NameUrl>.from(json["tags"].map((x) => NameUrl.fromJson(x))),
    buyLinks: List<BuyLink>.from(
      json["buy_links"].map((x) => BuyLink.fromJson(x)),
    ),
    publisher: json["publisher"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "cover_image": coverImage,
    "author": author.toJson(),
    "category": category.toJson(),
    "summary": summary,
    "details": details.toJson(),
    "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    "buy_links": List<dynamic>.from(buyLinks.map((x) => x.toJson())),
    "publisher": publisher,
  };
}

/// Simple pair of display name and URL reference
class NameUrl {
  String name;
  String url;

  NameUrl({required this.name, required this.url});

  factory NameUrl.fromJson(Map<String, dynamic> json) =>
      NameUrl(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class BuyLink {
  String store;
  String url;

  BuyLink({required this.store, required this.url});

  factory BuyLink.fromJson(Map<String, dynamic> json) =>
      BuyLink(store: json["store"], url: json["url"]);

  Map<String, dynamic> toJson() => {"store": store, "url": url};
}

class BookDetails {
  String noGm;
  String isbn;
  String price;
  String totalPages;
  String size;
  String publishedDate;
  String format;

  BookDetails({
    required this.noGm,
    required this.isbn,
    required this.price,
    required this.totalPages,
    required this.size,
    required this.publishedDate,
    required this.format,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) => BookDetails(
    noGm: json["no_gm"],
    isbn: json["isbn"],
    price: json["price"],
    totalPages: json["total_pages"],
    size: json["size"],
    publishedDate: json["published_date"],
    format: json["format"],
  );

  Map<String, dynamic> toJson() => {
    "no_gm": noGm,
    "isbn": isbn,
    "price": price,
    "total_pages": totalPages,
    "size": size,
    "published_date": publishedDate,
    "format": format,
  };
}
