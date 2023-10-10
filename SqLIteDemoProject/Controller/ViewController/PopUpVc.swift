//
//  PopUpVc.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import UIKit

class PopUpVc: UIViewController {
    
    var index : Int?
    var fname : String?
    var Lname : String?
    var Address : String?
    var ContactNo : String?
    var image : UIImage?
    var isimageSelected = false
    let imagePicker = UIImagePickerController()
    var initialmageName : String?
    var deigateMainVc : UserReload?
    
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeThePopUpVC()
    }
    
    
    
    func editData(index : Int , user : UserModelEditing) -> Bool{
        if deleteImageByIndex(index: index){
            let res = DatabaseManager.getInstance().edit(index: index, updatedInfo: user )
            return res
        }else{
            return false
        }
    }
    
    func deleteImageByIndex(index:Int) -> Bool{
        let fileManager = FileManager.default
        let imageurl = URL.documentsDirectory.appendingPathComponent(initialmageName ?? "").appendingPathExtension("png")
        do {
            try fileManager.removeItem(at: imageurl)
            return true
        } catch {
            return false
        }
    }
    func saveImageToDirectory(imageName:String){
        let fileUrl = URL.documentsDirectory.appending(component: imageName).appendingPathExtension("png")
        if let data = imgUser.image?.pngData(){
            do {
                try data.write(to: fileUrl)
            }catch{
                print("Saving image to Document Directory Error")
            }
        }
    }
    
    func initializeThePopUpVC(){
        txtFname.text = fname
        txtLname.text = Lname
        txtAddress.text = Address
        txtContactNo.text = ContactNo
        imgUser.image = image
    }
    
    @IBAction func onUploadImg(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        let imagename = UUID().uuidString
        let userdata = UserModelEditing(fName: txtFname.text ?? "" , lName: txtLname.text ?? "", address: txtAddress.text ?? "", contactNo: txtContactNo.text ?? "", imagename: imagename)
        if editData(index: index ?? 0, user: userdata){
            saveImageToDirectory(imageName: imagename)
            self.showAlert(msg: "Data edited Succesfully" , isDismiss: true)
            deigateMainVc?.reloadData()
        }else{
            self.showAlert(msg: "SomeThing went wrong")
        }
    }
}


extension PopUpVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheetForUploadImage(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallary()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        // alert.addAction(removeImageAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            isimageSelected = true
            image = img
            imgUser.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            isimageSelected = true
            image = img
            imgUser.image = image
        }
        
        //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}



