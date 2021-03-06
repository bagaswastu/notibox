import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/utils/ui_helpers.dart';

class CreateInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());
  Rx<bool> isReady = false.obs;
  Select? selectedLabel;
  DateTime? reminder;

  late RxInt chipIndex = 0.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<List<Select>> getListLabel() async {
    final listLabel = await _notionProvider.getListLabel();
    isReady.value = true;
    return listLabel;
  }

  bool isDraft() {
    return titleController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        selectedLabel != null ||
        reminder != null;
  }

  Future<void> saveInbox() async {
    hideInput();
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;

      if (selectedLabel?.id == 'no-label') {
        selectedLabel = null;
      }

      try {
        EasyLoading.show();
        final inbox = Inbox(
          title: title,
          description: description,
          label: selectedLabel,
          reminder: reminder,
        );
        final id = await _notionProvider.createInbox(inbox: inbox);
        inbox.pageId = id;
        EasyLoading.dismiss();
        Navigator.pop(Get.context!, inbox);
      } on HomeException catch (e) {
        await EasyLoading.dismiss();
        EasyLoading.showError(e.message);
      }
    }
  }
}
