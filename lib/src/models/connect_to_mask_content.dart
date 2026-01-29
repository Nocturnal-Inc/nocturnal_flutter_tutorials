import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_page.dart';

/// Static content for the 3-page mask-connection tutorial.
class ConnectToMaskContent {
  static const List<TutorialPage> pages = [
    TutorialPage(
      title: 'Turn On Mask / Charge',
      description:
          'Before connecting, make sure your mask is powered on or charging. '
          'Press and hold the power button for 3 seconds until the LED lights up.',
      contentType: ContentType.textAndImage,
      placeholderIcon: Icons.power,
      bulletPoints: [
        'Press and hold the power button for 3 seconds',
        'LED lights up when the mask is on',
        'Plug in the USB-C cable to charge if needed',
      ],
    ),
    TutorialPage(
      title: 'Find QR Code',
      description:
          'Locate the QR code printed on the inside of your mask. '
          'You will scan this code to pair the mask with the app.',
      contentType: ContentType.textAndImage,
      placeholderIcon: Icons.qr_code,
      bulletPoints: [
        'Look on the inner side of the mask frame',
        'Keep the QR code clean and visible',
        'Hold your phone camera steady when scanning',
      ],
    ),
    TutorialPage(
      title: 'Mask Connected',
      description:
          'Your mask is now connected and ready to use. '
          'The app will automatically sync with your mask each night.',
      contentType: ContentType.textAndImage,
      placeholderIcon: Icons.bluetooth_connected,
      bulletPoints: [
        'Bluetooth connection established',
        'Data will sync automatically',
        'Keep Bluetooth enabled for best results',
      ],
    ),
  ];
}
