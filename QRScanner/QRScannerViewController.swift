//
//  QRScannerViewController.swift
//  QRScanner
//
//  Created by Volhan Salai on 6/10/17.
//  Copyright © 2017 VolhanSalai. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logoHorizontalSmall")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        captureSession = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var input: AVCaptureDeviceInput
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            print(error)
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        else {
            self.scanFailed()
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
    
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        else {
            self.scanFailed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        qrCodeFrameView = UIView()
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func scanFailed() {
        let alert = UIAlertController(title: "Scanner QR no soportado", message: "Tu dispositivo no soporta lectura de códigos QR. Use un dispositivo con camara disponible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    func presentViewController(link: String) {
        if(verifyUrl(urlString: link)) {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsViewController.website = link
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            captureSession.stopRunning()
        } else {
            let alert = UIAlertController(title: "Documento no encontrado", message: "Asegurése que el código QR es el correcto e intente nuevamente", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Intentar nuevamente", style: .default, handler: {
                (action) in
                self.captureSession.startRunning()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func verifyUrl(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    presentViewController(link: metadataObj.stringValue)
                }
            }
        }
        
    }
}
