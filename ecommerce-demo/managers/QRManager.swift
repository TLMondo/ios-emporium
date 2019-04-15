//
//  QRManager.swift
//  DigitalVelocity
//
//  Created by Tealium User on 5/26/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//
//  Requirements: info.plist: 'Privacy - Camera Usage Description'

import UIKit
import AVFoundation
import QRCodeReader  //pod 'QRCodeReader.swift', '~> 8.2.0'

typealias QRManagerErrorBlock = (_ error: Error)->()
typealias QRManagerResultBlock = (_ valueScanned: String)->()

enum QRManagerError : Error {
    case noQRDataRead
}

class QRManager : QRCodeReaderViewControllerDelegate {
    
    static let shared = QRManager()
    weak var viewController: UIViewController?
    var onCancelBlock : (()->())?
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    func scanFrom(_ viewController: UIViewController,
                  success: @escaping QRManagerResultBlock,
                  error: @escaping QRManagerErrorBlock,
                  cancelled: @escaping ()->()) {
        
        onCancelBlock = cancelled
        
        self.viewController = viewController
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            guard let value = result?.value else {
                error(QRManagerError.noQRDataRead)
                return
            }
            success(value)
        }
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        viewController.present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = newCaptureDevice.device.localizedName
        print("Switching capturing to: \(cameraName)")
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        onCancelBlock?()
        self.viewController?.dismiss(animated: true, completion: nil)
    }

}
