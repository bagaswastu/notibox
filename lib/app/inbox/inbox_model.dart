import 'package:flutter/material.dart';

class Inbox {
  String? pageId;
  final String title;
  final String? description;
  final DateTime? reminder;
  final Select? label;

  Inbox({
    this.pageId,
    required this.title,
    required this.description,
    required this.reminder,
    required this.label,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map['Title'] = {
      'title': [
        {
          'text': {'content': title}
        }
      ]
    };

    map['Description'] = description != null
        ? {
            'rich_text': [
              {
                'text': {'content': description}
              }
            ]
          }
        : '';

    if (reminder != null) {
      map['Reminder'] = {
        'date': {'start': reminder!.toUtc().toIso8601String()}
      };
    } else {
      map['Reminder'] = {'date': null};
    }

    if (label != null) {
      map['Label'] = {'select': label!.toMap()};
    }

    return map;
  }

  factory Inbox.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final listTitle = (properties['Title']['title'] ?? []) as List;
    final description = properties['Description']?['rich_text'] as List;
    final label = properties['Label']?['select'] != null
        ? Select.fromMap(properties['Label']?['select'] as Map<String, dynamic>)
        : null;

    return Inbox(
      pageId: map['id'] as String,
      title: listTitle.isNotEmpty
          ? listTitle[0]['plain_text'] as String
          : 'Untitled',
      reminder: DateTime.tryParse(
              (properties['Reminder']?['date']?['start'] ?? '') as String)
          ?.toLocal(),
      label: label,
      description: description.isNotEmpty
          ? description[0]['plain_text'] as String
          : null,
    );
  }
}

class Select {
  final String? id;
  final String name;
  final Color? color;

  Select({this.id, required this.name, this.color});

  factory Select.fromMap(Map<String, dynamic> map) {
    late Color color;
    switch (map['color']) {
      case 'default':
        color = const Color(0xFFE6E6E4);
        break;
      case 'gray':
        color = const Color(0xFFD7D7D5);
        break;
      case 'brown':
        color = const Color(0xFFE8D5CC);
        break;
      case 'orange':
        color = const Color(0xFFFDDFCC);
        break;
      case 'yellow':
        color = const Color(0xFFFBEECC);
        break;
      case 'green':
        color = const Color(0xFFCCE7E1);
        break;
      case 'blue':
        color = const Color(0xFFCCE4F9);
        break;
      case 'purple':
        color = const Color(0xFFE1D3F8);
        break;
      case 'pink':
        color = const Color(0xFFF8CCE6);
        break;
      case 'red':
        color = const Color(0xFFFFCCD1);
        break;
      default:
        color = const Color(0xFFE6E6E4);
        break;
    }
    return Select(
        id: map['id'] as String, name: map['name'] as String, color: color);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
