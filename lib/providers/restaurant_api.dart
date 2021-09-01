const zlimit = 10;
List<String> zfilterName = [
  "Asian",
  "American",
  "BBQ",
  "Malay",
  "Seafood",
  "Bakery",
  "Breakfast",
  "Buffet",
  "Dessert",
  "Diner",
  "Fast Food",
  "Snack"
];
List<String> zfilterId = [
  "4bf58dd8d48988d142941735",
  "4bf58dd8d48988d14e941735",
  "4bf58dd8d48988d1df931735",
  "4bf58dd8d48988d156941735",
  "4bf58dd8d48988d1ce941735",
  "4bf58dd8d48988d16a941735",
  "4bf58dd8d48988d143941735",
  "52e81612bcbc57f1066b79f4",
  "4bf58dd8d48988d1d0941735",
  "4bf58dd8d48988d147941735",
  "4bf58dd8d48988d16e941735",
  "4bf58dd8d48988d1c7941735"
];

class RestaurantApi {
  final int limit = zlimit;
  final List<String> filterrName = zfilterName;
  final List<String> filterrId = zfilterId;
}
