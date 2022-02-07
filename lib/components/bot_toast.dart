import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/networking/response.dart';

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
CancelFunc Function(dynamic data, {String status, String? subTitle})
    showNotification = (data, {status = "success", subTitle}) {
  return BotToast.showCustomNotification(
    duration: Duration(seconds: 3),
    toastBuilder: (cancel) {
      return _CustomWidget(
        cancelFunc: cancel,
        title: (data.runtimeType == Response) ? data.message : data,
        subTitle: subTitle,
        backgroundColor: (data.runtimeType == Response)
            ? (data.success ? CustomColors.success : CustomColors.error)
            : (status == "success"
                ? CustomColors.success
                : (status == "warning"
                    ? CustomColors.warning
                    : CustomColors.error)),
      );
    },
    onlyOne: false,
  );
};

class _CustomWidget extends StatefulWidget {
  final CancelFunc cancelFunc;
  final String title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Color? backgroundColor;
  final double? borderRadius;
  final Icon closeIcon;
  final Widget? leading;
  final bool hideCloseButton;

  const _CustomWidget(
      {Key? key,
      required this.cancelFunc,
      required this.title,
      this.subTitle,
      this.titleStyle = const TextStyle(color: Colors.white),
      this.subTitleStyle = const TextStyle(color: Colors.white),
      this.backgroundColor,
      this.borderRadius = 8.0,
      this.closeIcon = const Icon(Icons.close),
      this.hideCloseButton = true,
      this.leading})
      : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<_CustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: widget.backgroundColor ?? CustomColors.success,
            shape: widget.borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius!),
                  ),
            child: ListTile(
                leading: widget.leading,
                title: Text(
                  widget.title,
                  style: widget.titleStyle,
                ),
                subtitle: widget.subTitle != null
                    ? Text(
                        widget.subTitle!,
                        style: widget.subTitleStyle,
                      )
                    : null,
                trailing: widget.hideCloseButton
                    ? null
                    : IconButton(
                        icon: widget.closeIcon, onPressed: widget.cancelFunc)),
          ),
        ));
  }
}
