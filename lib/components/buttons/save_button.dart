import 'package:flutter/material.dart';
import 'package:gereh/components/buttons/my_rounded_button.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/services/hive_actions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    Key? key,
    required this.data,
    this.backColor,
  }) : super(key: key);

  final AdvModel data;
  final Color? backColor;
  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isAvailable = false;

  void checkAvailability() async {
    isAvailable = await HiveActions.checkIfObjectExists(
        advModel: widget.data, box: 'bookmarks');
    setState(() {});
  }

  @override
  void initState() {
    checkAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyRoundedButton(
      elevation: 0,
      icon: Icon(
        isAvailable ? Iconsax.archive_11 : Iconsax.archive_add,
        color: isAvailable ? MyColors.red : Colors.black,
      ),
      backColor: widget.backColor ?? MyColors.backgroundColor,
      text: '',
      onClick: () async {
        var hive = await Hive.openBox('bookmarks');
        isAvailable
            ? HiveActions.deleteBookmark(advModel: widget.data, hive: hive)
            : HiveActions.addBookmark(advModel: widget.data, hive: hive);
        checkAvailability();
      },
    );
  }
}
