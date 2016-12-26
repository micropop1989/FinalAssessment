//
//  EditProfileViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView! {
        didSet {
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    
    var gender = ["Male", "Female"]
    var user = User()
    
    var currentid : String = ""
    var frDBref : FIRDatabaseReference!
    
    
    let imagePicker = UIImagePickerController()
    
    var fromVC : String? = ""
    var uploadedImage : UIImage?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        frDBref = FIRDatabase.database().reference()
        intinal()
        checkFromWhichController()
        //print(fromVC)
        
        
        
        genderLabel.isUserInteractionEnabled = true
        profilePicture.isUserInteractionEnabled = true
        let genderLabeltap = UITapGestureRecognizer(target:self,action:#selector(self.tapToShowPickerView(sender:)))
        let chooseImage = UITapGestureRecognizer(target:self, action:#selector(self.tapToOpenImagePicker(sender:)))
        genderLabel.addGestureRecognizer(genderLabeltap)
        
        profilePicture.addGestureRecognizer(chooseImage)
        
        
        imagePicker.delegate = self
    }
    
    
    @objc  private func tapToShowPickerView(sender: UITapGestureRecognizer) {
        genderPickerView.isHidden = false
    }
    
    
    @objc  private func tapToOpenImagePicker(sender: UITapGestureRecognizer) {
        //self.warningPopUp(withTitle: "tesstg", withMessage: "haha")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // let imagePicker = UIImagePickerController()
            //imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true, completion: nil)
        }
        
    }

   
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.addTarget(self, action: #selector(oncreateAccountButtonPressed), for: .touchUpInside)
            CustomUI().setButtonDesign(button: createAccountButton, color: UIColor.orange)
        }
    }
    
    
    @IBOutlet weak var updateAccountButton: UIButton! {
        didSet {
            updateAccountButton.addTarget(self, action: #selector(updateAccountButtonPressed), for: .touchUpInside)
            CustomUI().setButtonDesign(button: updateAccountButton, color: UIColor.orange)

            
        }
    }
    
    
    func oncreateAccountButtonPressed(button: UIButton) {
        let createAccountAlret = UIAlertController(title: "Sign Up Comfirmation", message: "Are you sure you want to sign up", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
            self.createAccount()
            
            

            print(FIRAuth.auth()?.currentUser?.uid)
            
        }
        
        createAccountAlret.addAction(noButton)
        createAccountAlret.addAction(yesButton)
        present(createAccountAlret, animated: true, completion: nil)
    }
    
    
    func updateAccountButtonPressed(button: UIButton) {
       
        let updateProfileAlret = UIAlertController(title: "Edit Comfirmation", message: "Are you sure you want to save this infomation", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
           
            self.changeProfileDetail()
            
            self.navigationController?.popViewController(animated: true)
        }
        
        updateProfileAlret.addAction(noButton)
        updateProfileAlret.addAction(yesButton)
        present(updateProfileAlret, animated: true, completion: nil)

        
    }
    
    func createAccount() {
        let auth = getAuth()
        let userinfo = getUserInfo()
         if auth.email == "" || auth.password == "" {
            
            return
        }
        
        if userinfo.username == "" || userinfo.age == "" || userinfo.gender == "" || userinfo.description == "" {
            
            return
        }
          FIRAuth.auth()?.createUser(withEmail: auth.email, password: auth.password) { (user, error) in
            if let createAccountError = error {
                self.warningPopUp(withTitle: "Error", withMessage: "Create Account error \(createAccountError)")
            
                return
            }
            
            guard let currentUser = user else{
                self.warningPopUp(withTitle: "Error", withMessage: "impossible current user not found error" )
               
                return
            }
            
            let userID = currentUser.uid
            
            
            
            let profilePictureURL = "https://firebasestorage.googleapis.com/v0/b/finalassessment-517e2.appspot.com/o/User%2FemptyPicture.jpeg?alt=media&token=608fc25c-935c-4a57-8b1c-af4a7a790da8"
            
            
            let dict = User().prepareUserDictionary(name: userinfo.username, email: auth.email, pictureURL: profilePictureURL, desc: userinfo.description, gender: userinfo.gender, age: userinfo.age)
            
            self.frDBref.child("User").child(userID).setValue(dict)
            
            if let uploadedImg = self.uploadedImage {
                helper().uploadImageToStorageAndGetUrl(image: uploadedImg, userID: userID)
            }
            
            
            self.user.userlogout()
            
        }
        
    }
    
    
    func changeProfileDetail()  {
        
        let userinfo = getUserInfo()
        let email = getEmail()
        
        if userinfo.username == "" || userinfo.age == "" || userinfo.gender == "" || userinfo.description == "" || email == "" {
            return
        }
        
        let profilePictureURL = self.user.profilepictureURL
        
        let dict = user.prepareUserDictionary(name: userinfo.username, email: email, pictureURL: profilePictureURL!, desc: userinfo.description, gender: userinfo.gender, age: userinfo.age)
        
        frDBref.child("User").child(currentid).setValue(dict)
        
        if let uploadedImg = self.uploadedImage {
            helper().uploadImageToStorageAndGetUrl(image: uploadedImg, userID: currentid)
        }
        
    }
    
    func changeAuth() {
        
    }
    
    
    func getAuth() -> (email : String, password : String) {
        guard
            let email = emailText.text,
            let password = passwordText.text
            else{
                self.warningPopUp(withTitle: "Error", withMessage: "email or password error")
                return ("", "")
        }
        if email == "" || password == "" {
            warningPopUp(withTitle: "input error", withMessage: "email or password can't empty")
            return ("", "")
        }
        
        return (email,password)
    
    }
    
    func getUserInfo() -> (username : String ,age : String ,gender : String , description : String)    {
        guard let username = nameText.text,
        let age = ageText.text,
        let description = descriptionText.text
            else {
                warningPopUp(withTitle: "Error", withMessage: "name,age or description  error")
                return("" ,"", "", "")
        }
        if username == "" || age == ""  {
            warningPopUp(withTitle: "Error", withMessage: "name,age can't empty")
            return("" ,"", "", "")
        }
        
        guard let gender  = genderLabel.text
            else {
                warningPopUp(withTitle: "Error", withMessage: "gender error")
                return("" ,"", "", "")
  
        }
        if gender == "gender" {
            warningPopUp(withTitle: "Error", withMessage: "please choose your gender")
            return("" ,"", "", "")

        }
        
        return(username , age , gender , description)
        
    }
    
    func getEmail() -> (String) {
        guard let email  = emailText.text
            else {
                warningPopUp(withTitle: "Error", withMessage: "gender error")
                return("")
                
        }
        if email == "email" {
            warningPopUp(withTitle: "Error", withMessage: "Email can't empty")
            return("")
            
        }
        
        return(email)
    }
    

    
    func checkFromWhichController() {
        if fromVC == "LoginController" {
            createAccountButton.isHidden = false
            updateAccountButton.isHidden = true
            self.title = "Create Accout"
            
        } else if fromVC == "My Profile" {
            createAccountButton.isHidden = true
            updateAccountButton.isHidden = false
            fillInDetail()
            self.title = "Edit Profile"
            passwordText.isHidden = true
        }
    }
    
    
    func intinal() {
        CustomUI().setGradientBackgroundColor(view: self.view, firstColor: UIColor.midNightBlue, secondColor: UIColor.dodgerBlue)
        descriptionText.placeholder  = "description"
        passwordText.placeholder = "password"
        emailText.placeholder = "email"
        nameText.placeholder = "name"
        ageText.placeholder = "age"
        
        genderLabel.text = "gender"
        genderLabel.textColor = UIColor.lightGray
        currentid = user.userID!
        
        
    }
    
    
    func fillInDetail() {
        nameText.text = user.name
        ageText.text = user.age
        genderLabel.text = user.gender
        genderLabel.textColor = UIColor.black
        emailText.text = user.email
        descriptionText.text = user.description
        
        if user.profilepictureURL == "" {
            
            let image = UIImage(named: "emptyPic.jpg")
        profilePicture = UIImageView(image: image)
        } else {
            profilePicture.loadImageUsingCacheWithUrlString(user.profilepictureURL!)
            
        }
    }
    
   
}

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = gender[row]
        genderLabel.textColor = UIColor.black
        
        pickerView.isHidden = true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        uploadedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.image = uploadedImage
        //profilePicture.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)

    }
}

extension EditProfileViewController: UINavigationControllerDelegate {
    
}


