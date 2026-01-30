import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';
import 'package:nocturnal_flutter_tutorials/src/models/section_type.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_section.dart';

class TutorialContent {
  static const List<TutorialSection> sections = [
    // Section 1: E pad
    TutorialSection(
      type: SectionType.ePad,
      sectionSubtitle: 'Buttons, lights, touchpoints & charging',
      pages: [
        TutorialPage(
          title: 'Plugging In Your Device',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/plugging_in.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Cable',
              description:
                  'Connect USB-C at top of E-pad.  Full charge ~2 hours.',
            ),
            InstructionPoint(
              headline: 'Charge time',
              description: 'Full charge takes approximately 2 hours.',
            ),
          ],
        ),
        TutorialPage(
          title: 'Charging status',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/charging_light.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Charging indicator',
              description: 'Green LEDs light up at the bottom of the E-pad.',
            ),
          ],
        ),
        TutorialPage(
          title: 'Turn on the mask',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/power_button.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Press once to power on',
              description: 'Powers on in ~10 seconds',
            ),
            InstructionPoint(
              headline: 'Correct power on',
              description: 'LEDs flash on facepad and mask vibrates',
            ),
          ],
        ),
        TutorialPage(
          title: 'Turn off the mask',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/poweroff.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Hold button to power off',
              description: 'Powers off in ~5 seconds',
            ),
            InstructionPoint(
              headline: 'Correct power off',
              description: 'Home screen indicates mask disconnection',
            ),
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
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/facepad_attach_detach.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Attach Face Pad',
              description: 'Align Velcro with cutouts',
            ),
            InstructionPoint(
              headline: 'Remove Face Pad',
              description: 'Pull from any edge to remove',
            ),
          ],
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
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/earloop_connector.mp4',
          placeholderIcon: Icons.hearing,
          instructionPoints: [
            InstructionPoint(
              headline: 'Connector',
              description: 'Magnetic end clicks into place',
            ),
            InstructionPoint(
              headline: 'Earloop',
              description:
                  'Front Velcro adjusts earloop position secure with a gentle tug',
            ),
          ],
        ),
        TutorialPage(
          title: 'Headstrap',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/headstrap.mp4',
          placeholderIcon: Icons.hearing,
          instructionPoints: [
            InstructionPoint(
              headline: 'Fabric',
              description: 'Wraps around your head to secure the mask',
            ),
            InstructionPoint(
              headline: 'Adjustment',
              description: 'Adjust Velcro for a comfortable fit',
            ),
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
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/hydrogels_bag.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Finding hydrogels',
              description: 'Remove hydrogels from the green bag',
            ),
            InstructionPoint(
              headline: 'Installing the hydrogels ',
              description:
                  'Press into each ear-loop hole until secure (4 total). (Tip: insert at a slight angle, then press around the edge)',
            ),
          ],
        ),
        TutorialPage(
          title: 'Hydrogel Maintenance',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/hydrogels_case.mp4',
          instructionPoints: [
            InstructionPoint(
              headline: 'Remove Hydrogels',
              description: 'Remove hydrogels the earloops',
            ),
            InstructionPoint(
              headline: 'Maintenance',
              description: 'Add a few drops of the solution to rehydrate',
            ),
          ],
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

  /// Pages for the experience-optimization tutorial flow.
  static const List<TutorialPage> experienceOptimizationPages = [
    TutorialPage(
      title: 'Initial setup',
      contentType: ContentType.gif,
      gifPath: 'assets/gifs/onboarding/calibration.gif',
      instructionPoints: [
        InstructionPoint(
          headline: 'Stimulation profiles',
          description:
              'We will find your optimal setting for vestibular stimulation',
        ),
        InstructionPoint(
          headline: 'Preperation',
          description:
              'Make sure your skin behind ears is clean, dry and free of hair and jewelry',
        ),
      ],
    ),
    TutorialPage(
      title: 'Device fitting',
      contentType: ContentType.portraitVideo,
      videoUrl: 'assets/videos/onboarding/earloop_placement.mp4',
      instructionPoints: [
        InstructionPoint(
          headline: 'Earloops',
          description: 'Move earloops around each ear',
        ),
        InstructionPoint(
          headline: 'Headstrap',
          description: 'Fasten headstrap around the back of the head',
        ),
      ],
    ),
    TutorialPage(
      title: 'Final step',
      contentType: ContentType.textAndImage,
      imagePath: 'assets/images/onboarding/mastoid.png',
      instructionPoints: [
        InstructionPoint(
          headline: 'Mastoid Contact',
          description:
              'Wear the mask and make sure the electrodes align with the mastoid as shown',
        ),
        InstructionPoint(
          headline: 'Confirmation',
          description:
              'Press back of earloop into skin to confirm hydrogels are touching skin',
        ),
      ],
    ),
  ];

  /// Pages for the mask-connection tutorial flow.
  static const List<TutorialPage> connectToMaskPages = [
    TutorialPage(
      title: 'Connection instructions',
      contentType: ContentType.textAndImage,
      imagePath: 'assets/images/onboarding/qr_code.png',
      instructionPoints: [
        InstructionPoint(
          headline: 'QR code',
          description: 'Find QR code included with the device',
        ),
        InstructionPoint(
          headline: 'Connection',
          description: 'Next screen: scan the QR code when the camera opens',
        ),
      ],
    ),
  ];
}
