class Interest {
  String? id;
  String? interestList;
  String? currentIndex;
  List<String> list = [];

  Interest({
    this.id,
    this.interestList,
    this.currentIndex,
  });

  Interest.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        interestList = json['interestList'],
        currentIndex = json['currentIndex'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'interestList': interestList,
        'currentIndex': currentIndex,
      };

  void initializeList() {
    // see if the initial interest list contains elements
    if (interestList != null) {
      String cleanedList =
          interestList.toString().replaceAll("[", "").replaceAll("]", "");
      list = cleanedList.split(", ");
    }
  }

  /// add interest to the object
  void addInterest(String interest) {
    if (list.length < 29) {
      list.add(interest);
    } else if (list.length == 29) {
      currentIndex = "0";
      list.add(interest);
    } else {
      // If current index had been added to the max, reset it to first position
      currentIndex == "30" ? currentIndex = "0" : null;

      int temp = int.parse(currentIndex.toString());
      list[temp] = interest;
      temp++;
      currentIndex = temp.toString();
    }
    interestList = list.toString();
  }

  /// Find 3 highest number of elements contain in the list
  List<String> ranking() {
    List<String> ranking = [];

    // Create a map to store the count of each element
    Map<String, int> countMap = {};

    // Count the occurences of each element
    for (String element in list) {
      // See if the element exists in the map,
      // if not, set it to 0 and add it by one
      countMap[element] = (countMap[element] ?? 0) + 1;
    }

    // Sort the map entries based on the count
    // in descending order
    List<MapEntry<String, int>> sortedEntries = countMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Extract the top three ranked elements if available
    ranking = sortedEntries.length >= 3
        ? sortedEntries.take(3).map((entry) => entry.key).toList()
        : sortedEntries.map((entry) => entry.key).toList();

    return ranking;
  }
}
