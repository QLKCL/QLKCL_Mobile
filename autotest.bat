@echo off
echo Login testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/login_test.dart

echo.
echo ==============================================
echo Forget password testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/forget_password_test.dart

echo.
echo ==============================================
echo Forget password testing...
call flutter drive --driver=test_driver/integration_test.dart --target=integration_test/quarantine_ward_test.dart
