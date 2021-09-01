import 'package:EatNow/providers/restaurant_api.dart';
import 'package:EatNow/providers/restaurant_state.dart';
import 'package:EatNow/screen/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFilters extends StatefulWidget {
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  @override
  Widget build(BuildContext context) {
    final api = Provider.of<RestaurantApi>(context);
    final state = Provider.of<RestaurantState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter Restaurant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Food Categories:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  (api.filterrName.length > 0)
                      ? Wrap(
                          spacing: 10,
                          children: List<Widget>.generate(
                              api.filterrName.length, (index) {
                            final category = api.filterrName;

                            final isSelected = state.searchOptions.categories
                                .contains(api.filterrId[index]);
                            return FilterChip(
                              label: Text(category[index]),
                              labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                  fontWeight: FontWeight.bold),
                              selected: isSelected,
                              selectedColor: Colors.orange[900],
                              checkmarkColor: Colors.grey,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    state.searchOptions.categories =
                                        state.searchOptions.categories +
                                            [api.filterrId[index]];
                                  } else
                                    state.searchOptions.categories
                                        .remove(api.filterrId[index]);
                                });
                              },
                            );
                          }),
                        )
                      : Center(child: Loading()),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Maximum Limits:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Slider(
                          value: (state.searchOptions.fLimit ?? 7).toDouble(),
                          activeColor: Colors.amber,
                          inactiveColor: Colors.orange,
                          min: 1,
                          max: api.limit.toDouble(),
                          divisions: 9,
                          label: state.searchOptions.fLimit?.toString(),
                          onChanged: (val) {
                            setState(() {
                              state.searchOptions.fLimit = val.round();
                            });
                          })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchOptions {
  List<String> categories = [];
  int fLimit;
  SearchOptions({this.fLimit});

  Map<String, dynamic> toJson() =>
      {'limit': fLimit, 'categoryId': categories.join(',')};
}
