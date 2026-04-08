import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';
import 'package:nocturnal_flutter_tutorials/src/models/section_type.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';

class TutorialContent {
  static const List<TutorialPage> sections = [
    TutorialPage(
      LeafPage(
        title: 'Nocturnal Onboarding',
        contentType: ContentType.text,
        instructionContent: BulletPoints(
          bullets: [
            'This tutorial is designed to help you get started with your Noche.',
            'This tutorial will guide you through the use and maintenance of each component.',
            'Please have the Noche ready next to you during this process.',
          ],
        ),
        footerText: "Time estimation: 10 minutes",
      ),
    ),
    TutorialPage(
      LeafPage(
        title: 'Main components',
        contentType: ContentType.textAndImage,
        imagePath: 'assets/images/onboarding/components.png',
        isScrollable: true,
        instructionContent: DetailedInstructions(
          points: [
            InstructionPoint(
              headline: 'E-pad',
              description:
                  'The E-pad houses all the sensors, battery and electronics for your Noche device.',
            ),
            InstructionPoint(
              headline: 'Facepad',
              description:
                  'The facepad is the interface between you and the E-pad, maximizing comfort while blocking external light.',
            ),
            InstructionPoint(
              headline: 'Earloops',
              description:
                  'The earloops help keep the Noche device around the ears and the head. Earloops also house the hydrogels which go behind your ear for neuromodulation.',
            ),
          ],
        ),
      ),
    ),
    TutorialPage(
      LeafPage(
        title: 'Accessories',
        contentType: ContentType.textAndImage,
        imagePath: 'assets/images/onboarding/accessories.png',
        instructionContent: DetailedInstructions(
          points: [
            InstructionPoint(
              headline: 'Hydrogels',
              description:
                  'Hydrogels are the electrical interface between the device and you.',
            ),
            InstructionPoint(
              headline: 'Hydrogel solution',
              description:
                  'This antibacterial saline solution is used to rehydrate the hydrogels.',
            ),
            InstructionPoint(
              headline: 'Hydrogel carrier case',
              description:
                  'Use this case to store and rehydrate the dried hydrogels when not in use.',
            ),
            InstructionPoint(
              headline: 'QR code',
              description:
                  'Use QR code to connect to the Noche when prompted by the app.',
            ),
          ],
        ),
      ),
    ),
    // Section 1: E pad
    TutorialPage(
      GroupPage(
        sectionType: SectionType.start,
        subtitle: "Now let's learn how to get started using the Noche.",
        imagePath: 'assets/images/onboarding/epad.png',
        children: [
          TutorialPage(
            LeafPage(
              title: 'Turning on the Noche',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/power_button.mp4',
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Press once to power on',
                    description:
                        'Press the power button for one second. The device will power on in approximately 10 seconds.',
                    tip:
                        "Note: if the mask is charging, it is already powered on",
                  ),
                  InstructionPoint(
                    headline: 'Correct power on',
                    description:
                        'A successful power-on is confirmed by a gentle vibration and flashing facepad lights. ',
                  ),
                ],
              ),
            ),
          ),
          TutorialPage(
            LeafPage(
              title: 'Turning off the Noche',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/poweroff.mp4',
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Hold button to power off',
                    description:
                        'To power off the device, press and hold the power button for approximately 5 seconds.',
                  ),
                  InstructionPoint(
                    headline: 'Correct power off',
                    description:
                        'A successful power-off is confirmed when the light on the device are off.',
                  ),
                ],
              ),
            ),
          ),
          TutorialPage(
            LeafPage(
              title: 'Charging Your Device',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/charging_light.mp4',
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Cable',
                    description:
                        'Connect the USB-C cable to the port on the top of the E-pad. Plugging in the device will also power it on. A successful power-on is confirmed by a gentle vibration and flashing facepad lights. ',
                  ),
                  InstructionPoint(
                    headline: 'Charging indicator',
                    description:
                        'Green LEDs at the bottom of the E-pad indicate that the device is charging. When the lights turn off, the device is fully charged. The device takes approximately 2 hours to fully charge.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),

    // Section 2: Facepad
    TutorialPage(
      GroupPage(
        sectionType: SectionType.facepad,
        subtitle: 'Removing and attaching the facepad.',
        imagePath: 'assets/images/onboarding/facepad.png',
        children: [
          TutorialPage(
            LeafPage(
              title: 'Attaching & Detaching',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/facepad_attach_detach.mp4',
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Remove Face Pad',
                    description:
                        'To remove the facepad, gently pull from any edge of the foam to detach it from the E-pad.',
                  ),
                  InstructionPoint(
                    headline: 'Attach Face Pad',
                    description:
                        'To attach the facepad, align the Velcro with the cutouts on the E-pad, then gently press and smooth the facepad into place.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),

    // Section 3: Hydrogels
    TutorialPage(
      GroupPage(
        sectionType: SectionType.hydrogels,
        subtitle:
            'These are the electrical interface between the device and the user',
        imagePath: 'assets/images/onboarding/hydrogels.png',
        children: [
          TutorialPage(
            LeafPage(
              title: 'Installing the hydrogels',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/hydrogels_installation.mp4',
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Unpacking the Hydrogels',
                    description: "Remove 4 hydrogels from the container.",
                  ),
                  InstructionPoint(
                    headline: 'Installation',
                    description:
                        "Pick up a hydrogel and insert it at a slight angle into one of the four divots in the earloop.",
                  ),
                  InstructionPoint(
                    headline: 'Technique',
                    description:
                        "Press gently around the edge of the hydrogel until it is fully secure.",
                  ),
                  InstructionPoint(
                    headline: 'Repetition',
                    description: "Repeat for all four hydrogels.",
                  ),
                ],
              ),
            ),
          ),
          TutorialPage(
            LeafPage(
              title: 'Hydrogel Maintenance',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/hydrogels_case.mp4',
              isScrollable: false,
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Remove Hydrogels',
                    description: 'Remove the hydrogels from the earloops.',
                  ),
                  InstructionPoint(
                    headline: 'Maintenance',
                    description:
                        'Hydrogels require hydration for optimal performance. New hydrogels are hydrated and ready to use. To rehydrate the hydrogels, store them in the container submerged in the saline solution, when not in use. We recommend rehydration every 1–2 days for best performance.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),

    // Section 4: Earloops
    TutorialPage(
      GroupPage(
        sectionType: SectionType.earloops,
        subtitle:
            'These attach the device around the face and contain the hydrogels.',
        imagePath: 'assets/images/onboarding/earloops.png',
        children: [
          TutorialPage(
            LeafPage(
              title: 'Connecting the Earloops',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/earloop_connector.mp4',
              placeholderIcon: Icons.hearing,
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Connector',
                    description:
                        'The earloops attach to the E-pad using a magnetic connector. To disconnect, gently pull on the fabric above the connector. To reattach, place the connector into the port and press gently until it clicks into place.',
                  ),
                  InstructionPoint(
                    headline: 'Earloop',
                    description:
                        'Use the Velcro on the front of the device to adjust the earloop position. Secure with a gentle tug for a comfortable fit.',
                  ),
                ],
              ),
            ),
          ),
          TutorialPage(
            LeafPage(
              title: 'Device Fitting',
              contentType: ContentType.video,
              videoUrl: 'assets/videos/onboarding/headstrap.mp4',
              placeholderIcon: Icons.hearing,
              instructionContent: DetailedInstructions(
                points: [
                  InstructionPoint(
                    headline: 'Secure Fit',
                    description:
                        'You have two adjustment points: lower front velcro and the headstrap.',
                  ),
                  InstructionPoint(
                    headline: 'Comfort',
                    description: 'Adjust to remove any pressure points.',
                  ),
                  InstructionPoint(
                    headline: 'Hydrogel/Mastoid Contact',
                    description:
                        'Adjust until hydrogels make good contact behind your ear.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ];

  static int get totalPageCount => sections.fold(0, (sum, page) {
    final type = page.type;
    return type is GroupPage ? sum + type.children.length : sum + 1;
  });

  /// Returns sections whose [sectionType] is not in [disabled].
  static List<TutorialPage> filteredSections(Set<SectionType> disabled) {
    if (disabled.isEmpty) return sections;
    return sections.where((page) {
      final type = page.type;
      if (type is GroupPage) return !disabled.contains(type.sectionType);
      return true;
    }).toList();
  }

  /// Pages for the experience-optimization tutorial flow.
  static const List<TutorialPage> experienceOptimizationPages = [
    TutorialPage(
      LeafPage(
        title: 'Instructions',
        contentType: ContentType.text,
        instructionContent: BulletPoints(
          bullets: [
            'Do not wear the mask just yet. We’ll guide you through how to put it on and ensure the hydrogels are correctly placed for optimal effectiveness.',
            'Make sure the skin behind your ears is clean and free of jewelry.',
            'Find a comfortable place to sit or lie down, you’ll begin your first experience shortly.',
            'Make sure the Mask is unplugged.',
          ],
        ),
      ),
    ),
    TutorialPage(
      LeafPage(
        title: 'Device fitting',
        contentType: ContentType.portraitVideo,
        videoUrl: 'assets/videos/onboarding/earloop_placement.mp4',
        instructionContent: DetailedInstructions(
          points: [
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
      ),
    ),
    TutorialPage(
      LeafPage(
        title: 'Hydrogel placement',
        contentType: ContentType.textAndImage,
        imagePath: 'assets/images/onboarding/mastoid.png',
        instructionContent: DetailedInstructions(
          points: [
            InstructionPoint(
              headline: 'Hydrogel Contact',
              description:
                  'Wear the mask and make sure the hydrogels align with the ear canal as shown.',
            ),
            InstructionPoint(
              headline: 'Confirmation',
              description:
                  'Locate the two indents on the earloop and use your index and middle fingers to gently press them against your skin to confirm that the hydrogels are making contact.',
            ),
          ],
        ),
      ),
    ),
    TutorialPage(
      LeafPage(
        title: 'Final steps',
        contentType: ContentType.text,
        instructionContent: BulletPoints(
          bullets: [
            'Get comfortable in the place where you plan to begin your experience.',
            'If you’re confident putting on the device, tap Start and put it on.',
            'In the next section, you’ll begin optimizing your experience by exploring a range of stimulation intensities. In rare cases, you may feel a mild tingling sensation behind your ears. This is normal and safe. If you do notice tingling, simply lower the intensity before testing again.',
          ],
        ),
      ),
    ),
  ];

  /// Pages for the mask-connection tutorial flow.
  static const List<TutorialPage> connectToMaskPages = [
    TutorialPage(
      LeafPage(
        title: 'Connection instructions',
        contentType: ContentType.textAndImage,
        imagePath: 'assets/images/onboarding/qr_code.png',
        instructionContent: DetailedInstructions(
          points: [
            InstructionPoint(
              headline: 'QR code',
              description: 'Find QR code included with the device',
            ),
            InstructionPoint(
              headline: 'Connection',
              description:
                  'Next screen: scan the QR code when the camera opens',
            ),
          ],
        ),
      ),
    ),
  ];
}
