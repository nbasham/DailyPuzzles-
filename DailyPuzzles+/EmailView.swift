import SwiftUI
import MessageUI
import AVFoundation

struct EmailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    static var hasEmail: Bool { MFMailComposeViewController.canSendMail() }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode

        init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            if result ==  MFMailComposeResult.sent {
                AudioServicesPlayAlertSound(SystemSoundID(1001))
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<EmailView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = context.coordinator
        let subject = "\(Bundle.main.appNameAndVersion) \(UIDevice.modelName) iOS: \(UIDevice.current.systemVersion)"
        mailVC.setToRecipients(["puzzlepleasure@gmail.com"])
        mailVC.setSubject(subject)
        return mailVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<EmailView>) {

    }
}
