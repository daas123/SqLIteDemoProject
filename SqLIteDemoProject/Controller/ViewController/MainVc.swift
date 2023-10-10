//
//  MainVc.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import UIKit
import SQLite3

class MainVc: UIViewController {
    
    var userdata : [UserModel]?
    var isimageSelected = false
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tblViewUserData: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewUserData.delegate = self
        tblViewUserData.dataSource = self
        fetchdata()
    }
    
    func fetchdata(){
        userdata = DatabaseManager.getInstance().fetch()
        tblViewUserData.reloadData()
    }
    
    func saveData(modelInfo:UserModelEditing) -> Bool{
        let isSave = DatabaseManager.getInstance().save(modelInfo)
        return isSave
    }
    
    func deleteData(index : Int) -> Bool{
        let res = DatabaseManager.getInstance().delete(atIndex: index)
        return res
    }
    
    func onInitializedTextFields(){
        txtFirstName.text = ""
        txtLname.text = ""
        txtContactNo.text = ""
        txtAddress.text = ""
        imgUser.image = UIImage(named: "user")
    }
    
    @IBAction func onUpload(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    @IBAction func onReset(_ sender: UIButton) {
        onInitializedTextFields()
    }
    func saveImageToDirectory(imageName:String){
        let fileUrl = URL.documentsDirectory.appending(component: imageName).appendingPathExtension("png")
        if let data = userImage.image?.pngData(){
            do {
                try data.write(to: fileUrl)
            }catch{
                print("Saving image to Document Directory Error")
            }
        }
    }
    
    
    @IBAction func onSave(_ sender: UIButton) {
        let imagename = UUID().uuidString
        let modelInfo = UserModelEditing(fName: txtFirstName.text ?? "" , lName: txtLname.text ?? "" , address: txtAddress.text ?? "" , contactNo: txtContactNo.text ?? "", imagename: imagename)
        guard isimageSelected == true else{
            self.showAlert(msg: "Select image")
            return
        }
        if saveData(modelInfo: modelInfo){
            saveImageToDirectory(imageName: imagename)
            self.showAlert(msg: "Data has been saved")
            fetchdata()
            tblViewUserData.reloadData()
            onInitializedTextFields()
        }else{
            self.showAlert(msg: "Some thing Went Worng")
        }
    }
    
}

extension MainVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDataCell
        cell.txtFname.text = userdata?[indexPath.row].fName
        cell.txtLname.text = userdata?[indexPath.row].lName
        cell.txtAddress.text = userdata?[indexPath.row].address
        cell.txtContactNo.text = userdata?[indexPath.row].contactNo
        let imageurl = URL.documentsDirectory.appending(components: userdata?[indexPath.row].imagename ?? "").appendingPathExtension("png")
        cell.imgUser.image = UIImage(contentsOfFile: imageurl.path)
        cell.DeligateMAinVc = self
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MainVc : UserActionOnCell{
    func onEdit(index : Int) {
        if let viewControllerToPresent = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVc") as? PopUpVc{
            viewControllerToPresent.fname = userdata?[index].fName
            viewControllerToPresent.Lname = userdata?[index].lName
            viewControllerToPresent.Address = userdata?[index].address
            viewControllerToPresent.ContactNo = userdata?[index].contactNo
            viewControllerToPresent.deigateMainVc = self
            viewControllerToPresent.initialmageName = userdata?[index].imagename
            let imageurl = URL.documentsDirectory.appending(components: userdata?[index].imagename ?? "").appendingPathExtension("png")
            viewControllerToPresent.image = UIImage(named: imageurl.path)
            let newIndex = userdata?[index].id
            viewControllerToPresent.index = newIndex
            self.present(viewControllerToPresent, animated: true)
        }
        
    }
    
    func onDelete(index : Int) {
        let newid = userdata?[index].id ?? 0
        if deleteData(index: newid){
            self.showAlert(msg: "Data Got Deleted Succesfully")
            fetchdata()
        }else{
            self.showAlert(msg: "Some thing went wrong")
        }
    }
    
}
extension MainVc : UserReload{
    func reloadData() {
        fetchdata()
    }
    
}

extension MainVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            userImage.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            isimageSelected = true
            image = img
            userImage.image = image
        }
        
      //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


