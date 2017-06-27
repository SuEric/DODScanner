//
//  DetailsViewController.swift
//  QRScanner
//
//  Created by Volhan Salai on 6/26/17.
//  Copyright © 2017 VolhanSalai. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var website: String?

    @IBAction func openPdf(_ sender: Any) {
        let pdfWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "PDFWebViewController") as! PDFWebViewController
        pdfWebViewController.website = website
        self.navigationController?.pushViewController(pdfWebViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
