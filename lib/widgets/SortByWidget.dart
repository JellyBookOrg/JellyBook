// Purpose: This file contains the SortByWidget widget, which is a stateful drop-down menu used to choose how to sort books.


import 'package:flutter/material.dart';
import 'package:jellybook/models/entry.dart';
import 'package:tentacle/tentacle.dart';
import 'package:collection/collection.dart';

enum SortOption {
  name("Name"),
  communityRating("Community Rating"),
  //criticsRating("Critics Rating"), //mising or N/A for books
  dateAdded("Date Added"),
  datePlayed("Date Played"),
  parentalRating("Parental Rating"),
  playCount("Play Count"),
  releaseDate("Release Date"),
  runtime("Runtime"),
  indexNum("Index Number");

  const SortOption(this.label);
  final String label;
}

class SortByWidget extends StatefulWidget {
  const SortByWidget({
    super.key,
    this.child,
    required this.defaultSortMethod,
    required this.defaultSortOrder,
    required this.onChanged,
  });

  final Widget? child;
  final SortOption defaultSortMethod;
  final SortOrder defaultSortOrder;
  final Future<void> Function(SortOption sortMethod, SortOrder sortDirection) onChanged;

  @override
  State<SortByWidget> createState() => _SortByState();

  static int compareEntries(Entry a, Entry b, SortOption sortMethod, SortOrder sortDirection) {
    String aString = a.sortName;
    String bString = b.sortName;
    switch (sortMethod) {
      case SortOption.name: //seriesSortName + sortName
        aString = '${a.seriesName},$aString';
        bString = '${b.seriesName},$bString';
        break;
      case SortOption.communityRating: //communityRating + sortName
        aString = '${a.communityRating},$aString';
        bString = '${b.communityRating},$bString';
        break;
      case SortOption.dateAdded: //dateCreated + sortName
        aString = '${a.dateCreated},$aString';
        bString = '${b.dateCreated},$bString';
        break;
      case SortOption.datePlayed: //datePlayed + sortName
        aString = '${a.lastPlayedDate},$aString';
        bString = '${b.lastPlayedDate},$bString';
        break;
      case SortOption.parentalRating: //officialRating + sortName
        aString = '${a.officialRating},$aString';
        bString = '${b.officialRating},$bString';
        break;
      case SortOption.playCount: //playCount + sortName
        aString = '${a.playCount},$aString';
        bString = '${b.playCount},$bString';
        break;
      case SortOption.releaseDate: //productionYear + premiereDate + sortName
        aString = '${a.releaseDate},${a.premiereDate},$aString';
        bString = '${b.releaseDate},${b.premiereDate},$bString';
        break;
      case SortOption.runtime: //runtime + sortName
        aString = '${a.runTimeTicks},$aString';
        bString = '${b.runTimeTicks},$bString';
        break;
      case SortOption.indexNum: //indexNumber + sortName
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

class _SortByState extends State<SortByWidget> {
  late SortOption _sortMethod;
  late SortOrder _sortDirection;

  @override
  void initState() {
    super.initState();
    _sortMethod = widget.defaultSortMethod;
    _sortDirection = widget.defaultSortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      initialValue: _sortMethod,
      onSelected: (SortOption sortMethod) {
        SortOrder sortDirection = _sortDirection;
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
        widget.onChanged.call(_sortMethod, _sortDirection);
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<SortOption>> itemList = [];
        for (SortOption option in SortOption.values) {
          if (_sortMethod == option) {
            IconData directionIcon;
            if (_sortDirection == SortOrder.ascending) {
              directionIcon = Icons.arrow_upward;
            } else {
              directionIcon = Icons.arrow_downward;
            }
            itemList.add(PopupMenuItem<SortOption>(
                value: option,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(option.label),
                    Icon(directionIcon),
                  ],
            )));
          } else {
            itemList.add(PopupMenuItem<SortOption>(
                value: option,
                child: Text(option.label),
            ));
          }
        }
        return itemList;
      },
      icon: const Icon(Icons.sort),
    );
  }
}