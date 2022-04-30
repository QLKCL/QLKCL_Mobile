@echo off
echo Login testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/login_test.dart

echo.
echo ==============================================
echo Forget password testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/forget_password_test.dart

echo.
echo ==============================================
echo Quarantine Ward testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/quarantine_ward_test.dart

echo.
echo ==============================================
echo Notification testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/notification_test.dart

echo.
echo ==============================================
echo Notification testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/quarantine_person_test.dart

echo.
echo ==============================================
echo Notification testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/medical_declaration_test.dart