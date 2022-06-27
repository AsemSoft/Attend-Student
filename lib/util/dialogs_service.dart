import 'package:flutter/material.dart';

class DialogsService {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context,
    String message, {
    void Function()? action,
    String? actionLabel,
    Duration duration = const Duration(seconds: 4),
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: duration,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: action ?? () {},
            )
          : null,
    ));
  }

  static Future<T?> showAlertDialog<T>(
    BuildContext context,
    Widget content, {
    Widget? title,
    void Function(BuildContext)? primaryAction,
    Widget primaryActionLabel = const Text('OK'),
    void Function(BuildContext)? secondaryAction,
    Widget? secondaryActionLabel,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            TextButton(
              child: primaryActionLabel,
              onPressed: () {
                if (primaryAction != null) {
                  primaryAction(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            if (secondaryActionLabel != null)
              TextButton(
                onPressed: secondaryAction != null
                    ? () => secondaryAction(context)
                    : null,
                child: secondaryActionLabel,
              )
          ],
        );
      },
    );
  }

  static Future<bool?> showQuestionDialog(BuildContext context, Widget content,
      {Widget? title}) {
    return showAlertDialog<bool>(
      context,
      content,
      title: title,
      primaryActionLabel: const Text('Yes'),
      primaryAction: (ctx) => Navigator.pop(ctx, true),
      secondaryActionLabel: const Text('No'),
      secondaryAction: (ctx) => Navigator.pop(ctx, false),
    );
  }

  static Future<T?> showChoiceDialog<T>(
      BuildContext context, List<T> items, Widget Function(T, int) builder,
      {Widget? title}) async {
    return await showAlertDialog(
      context,
      SizedBox(
        height: 256,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, i) => GestureDetector(
            onTap: () => Navigator.pop(context, items[i]),
            child: builder(items[i], i),
          ),
        ),
      ),
      title: title,
    );
  }

  static Future<String?> showSimpleChoiceDialog<String>(
      BuildContext context, List<String> items,
      {Widget? title}) async {
    return await showChoiceDialog(
      context,
      items,
      (item, _) => Text(item.toString()),
      title: title,
    );
  }

  static Future<T?> showFutureChoiceDialog<T>(BuildContext context,
      Future<List<T>> itemsFuture, Widget Function(T, int) builder,
      {Widget? title}) async {
    return await showAlertDialog(
      context,
      FutureBuilder<List<T>>(
        future: itemsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Text('Could not load items');
          } else if (snapshot.hasData) {
            return SizedBox(
              height: 256,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, i) => InkWell(
                  onTap: () => Navigator.pop(context, snapshot.data![i]),
                  child: builder(snapshot.data![i], i),
                ),
              ),
            );
          } else {
            return const SizedBox(
              height: 128,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      title: title,
    );
  }
}
