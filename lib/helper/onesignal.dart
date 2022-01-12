import 'package:onesignal_flutter/onesignal_flutter.dart';

void handleSendTags(String key, String value) {
  print("Sending tags");
  OneSignal.shared.sendTag(key, value).then((response) {
    print("Successfully sent tags with response: $response");
  }).catchError((error) {
    print("Encountered an error sending tags: $error");
  });
}

void handleDeleteTag(String key) {
  print("Deleting tag");
  OneSignal.shared.deleteTag(key).then((response) {
    print("Successfully deleted tags with response $response");
  }).catchError((error) {
    print("Encountered error deleting tag: $error");
  });
}

void handleSetExternalUserId(String externalUserId) {
  print("Setting external user ID");

  OneSignal.shared.setExternalUserId(externalUserId).then((results) {
    print("External user id set: $results");
  });
}

void handleRemoveExternalUserId() {
  OneSignal.shared.removeExternalUserId().then((results) {
    print("External user id removed: $results");
  });
}

void handlePromptForPushPermission() {
  print("Prompting for Permission");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

void handleGetDeviceState() async {
  print("Getting DeviceState");
  OneSignal.shared.getDeviceState().then((deviceState) {
    print("DeviceState: ${deviceState?.jsonRepresentation()}");
  });
}

void handleSendNotification() async {
  var deviceState = await OneSignal.shared.getDeviceState();

  if (deviceState == null || deviceState.userId == null) return;

  var playerId = deviceState.userId!;

  var imgUrlString =
      "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

  var notification = OSCreateNotification(
      playerIds: [playerId],
      content: "this is a test from OneSignal's Flutter SDK",
      heading: "Test Notification",
      iosAttachments: {"id1": imgUrlString},
      bigPicture: imgUrlString,
      buttons: [
        OSActionButton(text: "test1", id: "id1"),
        OSActionButton(text: "test2", id: "id2")
      ]);

  var response = await OneSignal.shared.postNotification(notification);
  print("Sent notification with response: $response");
}

oneSignalInAppMessagingTriggerExamples() async {
  /// Example addTrigger call for IAM
  /// This will add 1 trigger so if there are any IAM satisfying it, it
  /// will be shown to the user
  OneSignal.shared.addTrigger("trigger_1", "one");

  /// Example addTriggers call for IAM
  /// This will add 2 triggers so if there are any IAM satisfying these, they
  /// will be shown to the user
  Map<String, Object> triggers = new Map<String, Object>();
  triggers["trigger_2"] = "two";
  triggers["trigger_3"] = "three";
  OneSignal.shared.addTriggers(triggers);

  // Removes a trigger by its key so if any future IAM are pulled with
  // these triggers they will not be shown until the trigger is added back
  OneSignal.shared.removeTriggerForKey("trigger_2");

  // Get the value for a trigger by its key
  Object? triggerValue =
      await OneSignal.shared.getTriggerValueForKey("trigger_3");
  print("'trigger_3' key trigger value: ${triggerValue?.toString()}");

  // Create a list and bulk remove triggers based on keys supplied
  List<String> keys = ["trigger_1", "trigger_3"];
  OneSignal.shared.removeTriggersForKeys(keys);

  // Toggle pausing (displaying or not) of IAMs
  OneSignal.shared.pauseInAppMessages(false);
}

oneSignalOutcomeEventsExamples() async {
  // Await example for sending outcomes
  outcomeAwaitExample();

  // Send a normal outcome and get a reply with the name of the outcome
  OneSignal.shared.sendOutcome("normal_1");
  OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
    print(outcomeEvent.jsonRepresentation());
  });

  // Send a unique outcome and get a reply with the name of the outcome
  OneSignal.shared.sendUniqueOutcome("unique_1");
  OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
    print(outcomeEvent.jsonRepresentation());
  });

  // Send an outcome with a value and get a reply with the name of the outcome
  OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
  OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
    print(outcomeEvent.jsonRepresentation());
  });
}

Future<void> outcomeAwaitExample() async {
  var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
  print(outcomeEvent.jsonRepresentation());
}
