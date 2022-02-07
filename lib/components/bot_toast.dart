import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';

// TextToast
CancelFunc Function(String) showTextToast = (text) {
  return BotToast.showText(
    text: text,
    textStyle: TextStyle(color: CustomColors.primaryText, fontSize: 14.0),
    contentPadding: EdgeInsets.all(16),
    contentColor: CustomColors.background,
    wrapToastAnimation: (controller, cancel, Widget child) =>
        CustomAnimationWidget(
      controller: controller,
      child: child,
    ),
  );
};

class CustomAnimationWidget extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomAnimationWidget(
      {Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  _CustomAnimationWidgetState createState() => _CustomAnimationWidgetState();
}

class _CustomAnimationWidgetState extends State<CustomAnimationWidget> {
  static final Tween<Offset> tweenOffset = Tween<Offset>(
    begin: const Offset(0, 40),
    end: const Offset(0, 0),
  );

  static final Tween<double> tweenScale = Tween<double>(begin: 0.7, end: 1.0);
  late Animation<double> animation;

  @override
  void initState() {
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: animation,
      builder: (BuildContext? context, Widget? child) {
        return Transform.translate(
          offset: tweenOffset.evaluate(animation),
          child: Transform.scale(
            scale: tweenScale.evaluate(animation),
            child: Opacity(
              child: child,
              opacity: animation.value,
            ),
          ),
        );
      },
    );
  }
}

// Loading
CancelFunc Function({String? textLoading}) showLoading = ({textLoading}) {
  return BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
    return _CustomLoadWidget(cancelFunc: cancelFunc, textLoading: textLoading);
  });
};

class _CustomLoadWidget extends StatefulWidget {
  final CancelFunc cancelFunc;
  final String? textLoading;

  const _CustomLoadWidget(
      {Key? key, required this.cancelFunc, this.textLoading})
      : super(key: key);

  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState();
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              widget.textLoading ?? "Loading",
            ),
          )
        ],
      ),
    );
  }
}

// Notification
void Function(String title, {String status, String? subTitle})
    showNotification = (title, {status = "success", subTitle}) {
  BotToast.showSimpleNotification(
    title: title,
    subTitle: subTitle,
    onlyOne: false,
    crossPage: false,
    duration: Duration(seconds: 5),
    backgroundColor: status == "success"
        ? CustomColors.success
        : (status == "warning" ? CustomColors.warning : CustomColors.error),
    titleStyle: const TextStyle(color: Colors.white),
    subTitleStyle: const TextStyle(color: Colors.white),
  );
};
