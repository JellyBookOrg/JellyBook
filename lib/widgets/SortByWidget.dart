// Purpose: This file contains the SortBy widget, which is a stateful drop-down menu used to choose how to sort books.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jellybook/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tentacle/tentacle.dart';
import 'package:collection/collection.dart';

enum SortMethod {
  sortName("Name"),
  rating("Rating"),
  //criticsRating("Critics Rating"),
  dateAdded("Date Added"),
  datePlayed("Date Played"),
  //parentalRating("Parental Rating"),
  playCount("Play Count"),
  releaseDate("Release Date"),
  runtime("Runtime"),
  indexNum("Index Number");

  const SortMethod(this.label);
  final String label;
}

class SortByWidget extends StatefulWidget {
  const SortByWidget({
    super.key,
    this.child,
    required this.defaultSortMethod,
    required this.defaultSortDirection,
    this.sharedPrefsKey,
    required this.onChanged,
  });

  final Widget? child;
  final SortMethod defaultSortMethod;
  final SortOrder defaultSortDirection;
  final String? sharedPrefsKey;
  final Future<void> Function(SortMethod sortMethod, SortOrder sortDirection) onChanged;

  @override
  State<SortByWidget> createState() => _SortByState();
}

class _SortByState extends State<SortByWidget> {
  final Completer _prefsLoaded = Completer();
  SortMethod? _sortMethod;
  SortOrder? _sortDirection;
  SharedPreferences? _preferences;

  @override
  void initState() {
    super.initState();
    loadPrefs().then((_) {
      _sortMethod ??= widget.defaultSortMethod;
      _sortDirection ??= widget.defaultSortDirection;
      _prefsLoaded.complete();
      widget.onChanged.call(_sortMethod!, _sortDirection!);
    });
  }

  Future<void> loadPrefs() async {
    if (widget.sharedPrefsKey != null) {
      _preferences = await SharedPreferences.getInstance();
      String? sortMethodString = _preferences!.getString("${widget.sharedPrefsKey!}.sortMethod");
      String? sortDirectionString = _preferences!.getString("${widget.sharedPrefsKey!}.sortDirection");
      if (sortMethodString != null && sortDirectionString != null) {
        _sortMethod = SortMethod.values.byName(sortMethodString);
        _sortDirection = SortOrder.valueOf(sortDirectionString);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefsLoaded.future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return PopupMenuButton<SortMethod>(
        initialValue: _sortMethod,
        onSelected: (SortMethod sortMethod) {
          SortOrder sortDirection = _sortDirection!;
          if (sortMethod == _sortMethod) {
            if (sortDirection == SortOrder.ascending) {
              sortDirection = SortOrder.descending;
            } else {
              sortDirection = SortOrder.ascending;
            }
          } else {
            sortDirection = SortOrder.ascending;
          }
          setState(() {
            _sortMethod = sortMethod;
            _sortDirection = sortDirection;
          });
          if (widget.sharedPrefsKey != null) {
            _preferences!.setString(
              "${widget.sharedPrefsKey!}.sortMethod", _sortMethod!.name);
            _preferences!.setString(
              "${widget.sharedPrefsKey!}.sortDirection", _sortDirection!.name);
          }
          widget.onChanged.call(_sortMethod!, _sortDirection!);
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem<SortMethod>> itemList = [];
          for (SortMethod option in SortMethod.values) {
            if (_sortMethod == option) {
              IconData directionIcon;
              if (_sortDirection == SortOrder.ascending) {
                directionIcon = Icons.arrow_upward;
              } else {
                directionIcon = Icons.arrow_downward;
              }
              itemList.add(PopupMenuItem<SortMethod>(
                  value: option,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(option.label),
                      Icon(directionIcon),
                    ],
              )));
            } else {
              itemList.add(PopupMenuItem<SortMethod>(
                  value: option,
                  child: Text(option.label),
              ));
            }
          }
          return itemList;
        },
        icon: const Icon(Icons.sort),
      );}
    );
  }
}

class SortFunctions {
  static int compareEntries(Entry a, Entry b, SortMethod sortMethod, SortOrder sortDirection) {
    String aString = a.sortName.toLowerCase().trim();
    String bString = b.sortName.toLowerCase().trim();
    if (aString == '') {
      aString = a.title.toLowerCase().trim();
    }
    if (bString == '') {
      bString = b.title.toLowerCase().trim();
    }

    switch (sortMethod) {
      case SortMethod.sortName: //seriesSortName + sortName
        aString = '${a.seriesName.toLowerCase()},$aString';
        bString = '${b.seriesName.toLowerCase()},$bString';
        break;
      case SortMethod.rating: //communityRating + sortName
        aString = '${a.rating},$aString';
        bString = '${b.rating},$bString';
        break;
      case SortMethod.dateAdded: //dateCreated + sortName
        aString = '${a.dateCreated},$aString';
        bString = '${b.dateCreated},$bString';
        break;
      case SortMethod.datePlayed: //datePlayed + sortName
        aString = '${a.lastPlayedDate},$aString';
        bString = '${b.lastPlayedDate},$bString';
        break;
      case SortMethod.playCount: //playCount + sortName
        aString = '${a.playCount},$aString';
        bString = '${b.playCount},$bString';
        break;
      case SortMethod.releaseDate: //productionYear + premiereDate + sortName
        aString = '${a.releaseDate},${a.premiereDate},$aString';
        bString = '${b.releaseDate},${b.premiereDate},$bString';
        break;
      case SortMethod.runtime: //runtime + sortName
        aString = '${a.runTimeTicks},$aString';
        bString = '${b.runTimeTicks},$bString';
        break;
      case SortMethod.indexNum: //indexNumber + sortName
        aString = '${a.indexNumber},$aString';
        bString = '${b.indexNumber},$bString';
        break;
      default: //just sortName
        break;
    }

    if (sortDirection == SortOrder.ascending) {
      return compareNatural(aString, bString);
    } else {
      return compareNatural(aString, bString) * -1;
    }
  }
}