//
//  PDFWebViewController.swift
//  QRScanner
//
//  Created by Volhan Salai on 6/15/17.
//  Copyright © 2017 VolhanSalai. All rights reserved.
//

import UIKit

class PDFWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var website: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let reqURL = URL(string: website!)
        let request = URLRequest(url: reqURL!)
        
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
