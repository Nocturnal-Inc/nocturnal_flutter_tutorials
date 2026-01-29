import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_page.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_section.dart';

class TutorialContent {
  static const List<TutorialSection> sections = [
    // Section 1: E pad
    TutorialSection(
      type: SectionType.ePad,
      sectionSubtitle: 'Buttons, lights, touchpoints & charging',
      pages: [
        TutorialPage(
          title: 'Plugging In Your Device',
          description:
              'Connect the USB-C cable to the charging port on the top of your E pad.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/plugging_in.mp4',
          bulletPoints: [
            'Use a USB-C cable',
            'Full charge takes approximately 2 hours',
          ],
        ),
        TutorialPage(
          title: 'Charging status',
          description:
              'When the mask is being charged. You should notice green LEDs at the bottom of the E-pad light up green.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/charging_light.mp4',
          bulletPoints: ['Green LEDs on both sides of E-pad'],
        ),
        TutorialPage(
          title: 'Power button',
          description:
              'You can find the power button next to the USB-C socket at the top of the E-pad.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/power_button.mp4',
          bulletPoints: [
            'Press once to turn on the mask. You will see the mask initialize in 10s',
            'During initialization you would see the LEDs go off as shown',
            'Also, device vibrates on successful initialization',
            'To turn off the device, press and hold the button for 5s',
          ],
        ),
      ],
    ),

    // Section 2: Facepad
    TutorialSection(
      type: SectionType.facepad,
      sectionSubtitle: 'Attaching and detaching',
      pages: [
        TutorialPage(
          title: 'Attaching & Detaching the Face pad',
          description:
              'Align the velcro part of the face pad with the e-pad. Such that the cut outs align perfectly.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/facepad_attach_detach.mp4',
          bulletPoints: ['Pull from any edge to detach'],
        ),
      ],
    ),

    // Section 3: Earloops
    TutorialSection(
      type: SectionType.earloops,
      sectionSubtitle: 'Connecting and adjusting',
      pages: [
        TutorialPage(
          title: 'Connecting the Earloops',
          description:
              'Earloops have magnetic connector on one end and velcro strap on the other.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/earloop_connector.mp4',
          placeholderIcon: Icons.hearing,
          bulletPoints: [
            'Notice click sound when the magnetic connector is connected.',
            'Velcro is adjustable',
            'Secure with gentle tug',
          ],
        ),
      ],
    ),

    // Section 4: Hydrogels
    TutorialSection(
      type: SectionType.hydrogels,
      sectionSubtitle: 'Unpacking and refreshing',
      pages: [
        TutorialPage(
          title: 'Unpacking the Hydrogels',
          description:
              'Take the electrodes out of the plastic bag. Place them in the cavities on the earloop and lock them in place.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/hydrogels_bag.mp4',
          bulletPoints: [
            'Pair of electrodes goes on each earloop',
            'Make sure it gets locked in place as it is placed',
          ],
        ),
        TutorialPage(
          title: 'Hydrogel Refreshment',
          description:
              'After each use, remove the hydrogels and place it in the contact lens case.',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/hydrogels_case.mp4',
          // bulletPoints: ['Replace every 2-4 weeks'],
        ),
      ],
    ),
  ];

  static int get totalPageCount =>
      sections.fold(0, (sum, section) => sum + section.pages.length);

  /// Returns sections whose [type] is not in [disabled].
  static List<TutorialSection> filteredSections(Set<SectionType> disabled) {
    if (disabled.isEmpty) return sections;
    return sections.where((s) => !disabled.contains(s.type)).toList();
  }
}
