//
//  UpdateProfileViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 27/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class UpdateProfileViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnFetchProfileImage: UIButton!
    
    //MARK:- Variables
    var isEditingProfile = false
    var profileImage: UIImage?
    
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCurrentProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.delegate = self
            container.setBackButton()
            container.setTitle(NavigationTitles.UpdateProfile)
        }
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.profileImage = image
            self.imgProfileImage.image = image
        }else if let image = info[.originalImage] as? UIImage {
            self.profileImage = image
            self.imgProfileImage.image = image
        }
        
        self.profileImagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Custom methods
    fileprivate func loadCurrentProfile() {
        if let user = Global.shared.user {
            txtName.text = user.name
            txtEmail.text = user.email
            self.imgProfileImage.sd_setImage(with: URL(string: user.avatar), placeholderImage: self.imgProfileImage.image(with: user.name))
        }
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func enableProfileEditing() {
        self.isEditingProfile = true
        self.txtName.textColor = .black
        self.txtEmail.textColor = .black
        self.txtName.isUserInteractionEnabled = true
        self.btnFetchProfileImage.isUserInteractionEnabled = true
        self.btnEditProfile.setTitle(LocalStrings.updateProfile, for: .normal)
    }
    
    //MARK:- Action methods
    @IBAction func actionUpdateProfileImage(_ sender: Any) {
        self.profileImagePicker.allowsEditing = true
        self.fetchProfileImage()
    }
    
    @IBAction func actionUpdateProfile(_ sender: UIButton) {
        if !isEditingProfile {
            self.enableProfileEditing()
        }else {
            let nameValidation = Validations.nameValidation(txtName.text!)
            
            if !nameValidation.isValid {
                self.showAlertView(message: nameValidation.message)
            }else {
                let params:ParamsString = [DictKeys.userId:String(Global.shared.user.id),
                                           DictKeys.name:nameValidation.text]
                self.updateProfile(with: params)
            }
        }
    }
    
}

//MARK:- API Call
extension UpdateProfileViewController {
    fileprivate func updateProfile(with params: ParamsString) {
        self.startActivity()
        GCD.async(.Background) {
            RegisterationService.shared().updateUserProfile(params: params, profileImage: self.profileImage) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.showAlertView(message: message)
                }
            }
        }
    }
}
