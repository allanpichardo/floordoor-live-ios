//
//  EmailViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/23/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
    
    public var selections: Set<Int>?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Downloads"
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        requestDownload()
    }
    
    private func requestDownload(){
        if let selections = selections {
            Api.requestDownloads(selections.sorted(), email: emailText.text!, callback: { (response) in
                if response.isSuccess! {
                    self.convertLayoutToPostSent()
                } else {
                    self.alertErrorOccured()
                }
            })
        }
    }
    
    @IBAction func doneClicked(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    private func alertErrorOccured() {
        let alert = UIAlertController(title: "Something Went Wrong", message: "We were unable to send you your download links. Try again soon, we're working on it.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    @IBAction func textChanged(_ sender: Any) {
        guard let email = emailText.text else {
            sendButton.isEnabled = false
            return
        }
        sendButton.isEnabled = validateEmail(enteredEmail: email)
    }
    
    private func convertLayoutToPostSent(){
        emailText.isHidden = true
        sendButton.isHidden = true
        messageLabel.text = "Check your email shortly. Thanks for your support!"
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
