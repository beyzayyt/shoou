import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:show_you/data/localization/app_constant.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/ui/page/home_page.dart';

class ChangeLanguage extends StatelessWidget {
  final SavedUserModel? savedUserModel;

  const ChangeLanguage({super.key, required this.savedUserModel});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      context.setLocale(AppConstant.enlocale).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          ));
                    },
                    child: Text(LocaleKeys.english.tr()),
                  ),
                  const SizedBox(height: 16), 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      context.setLocale(AppConstant.trlocale).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          ));
                    },
                    child: Text(LocaleKeys.turkish.tr()),
                  ),
                ],
              ),
            );
          },
        );
      },
      color: Theme.of(context).primaryColor,
      icon: Row(
        children: [
          const Icon(Icons.language),
          const SizedBox(
            width: 8,
          ),
          Text(
            LocaleKeys.changeLanguage.tr(),
            style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
          )
        ],
      ),
    );
  }
}
