//
//  ViewController.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 15/12/22.
//

import UIKit
import PhotosUI
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    var flag  =  true
    var arrayOfImage: [UIImage] = []
    var fileManager = FileManager.default
    var folderUrl: URL?
    var imageUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let collectionNib =  UINib(nibName:"ItemCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: "itemCell")
        collectionView.layer.cornerRadius = 50
        
        // MARK: - Default View - Grid View
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: horGroup, subitems: [item])
        let groupInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        group.contentInsets = groupInsets
        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = compLayout
        
        //MARK: - Default Image for Button
        gridButton.setImage(UIImage(systemName:"square.grid.2x2.fill"), for: .normal)
        listButton.setImage(UIImage(systemName:"plus"), for: .normal)
        
    }
    
    //MARK: - View Change Button
    @IBAction func changeView(_ sender: Any) {
        
        if flag{
            flag = false
            gridViewListView(viewStyle: true)
            gridButton.setImage(UIImage(systemName:"rectangle.grid.1x2.fill"), for: .normal)
            
        }else{
            flag = true
            gridViewListView(viewStyle: false)
            gridButton.setImage(UIImage(systemName:"square.grid.2x2.fill"), for: .normal)
        }
    }
    
    //MARK: - Picker Section
    @IBAction func selectImage(_ sender: Any) {
        pickImageMethod()
    }
    
    // MARK: - Picker Section
    func  pickImageMethod(){
        let alert = UIAlertController(title: "Choose Method", message: "", preferredStyle: .alert)
        let phpPicker = UIAlertAction(title: "Php Picker", style: .default){[weak self]_ in
            guard let self = self else {return}
            self.showPhpPicker()
        }
        let imagePicker = UIAlertAction(title: "Image Picker", style: .default){[weak self]_ in
            guard let self = self else {return}
            self.imagePicker()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default){_ in
            alert.dismiss(animated: true)
            
        }
        alert.addAction(phpPicker)
        alert.addAction(imagePicker)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func imagePicker(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    func showPhpPicker(){
        var phPickerConfig = PHPickerConfiguration()
        phPickerConfig.selectionLimit = 10
        phPickerConfig.filter = .images
        let phpPicker = PHPickerViewController(configuration: phPickerConfig)
        phpPicker.delegate = self
        present(phpPicker, animated: true)
    }
    
    // MARK: - View Changing Section
    func gridView()->UICollectionViewLayout{
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: horGroup, subitems: [item])
        let groupInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        group.contentInsets = groupInsets
        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        return compLayout
    }
    func listView()->UICollectionViewLayout{
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        
        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: horGroup, subitems: [item])
        let groupInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        group.contentInsets = groupInsets
        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        return compLayout
    }
    
    // MARK: - Choosing View Style
    
    func gridViewListView(viewStyle: Bool){
        gridButton.isUserInteractionEnabled = false
        listButton.isUserInteractionEnabled = false
        collectionView.startInteractiveTransition(to: viewStyle ? gridView() : listView()){[weak self]_,_ in
            guard let self = self else{return}
            self.gridButton.isUserInteractionEnabled = true
            self.listButton.isUserInteractionEnabled = true
        }
        
        collectionView.finishInteractiveTransition()
    }
}

// MARK: - Collection View Delegate Section

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(indexpath: indexPath)
    }
    func  showAlert(indexpath: IndexPath){
        let alert = UIAlertController(title: "Save to Local Directory", message: "", preferredStyle: .actionSheet)
        let saveImage = UIAlertAction(title: "Save", style: .default){[weak self]_ in
            guard let self = self else {return}
            self.saveImageToLocal(indexPath: indexpath)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default){_ in
            alert.dismiss(animated: true)
        }
        alert.addAction(saveImage)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func createFileManager(){
        
        guard let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        folderUrl = documentUrl.appendingPathComponent("DCIM")
        
    }
    func createFolder(){
        do {
            if let url = folderUrl{
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            }
        } catch {
            print(error)
        }
    }
    func saveImageToLocal(indexPath: IndexPath){
        createFileManager()
        createFolder()
        if let folderUrl = folderUrl{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dates = formatter.string(from: date)
            print(folderUrl.path)
            imageUrl = folderUrl.appendingPathComponent("image "+dates+".png")
            let  image = self.arrayOfImage[indexPath.row]
            fileManager.createFile(atPath: imageUrl!.path, contents: image.pngData())
        }
    }
}

// MARK: - Collection View DataSource Section

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfImage.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item =  collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        item.imageView.image =  self.arrayOfImage[indexPath.row]
        item.layer.cornerRadius = 40
        return item
    }
    
    
}


// MARK: - PHP picker

extension ViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
                [weak self] (image, error) in
                guard let self = self else {return}
                if let image = image as? UIImage {
                    self.arrayOfImage.append(image)
                    DispatchQueue.main.async {
                        print(self.arrayOfImage.count)
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Image Picker
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            arrayOfImage.append(image)
            collectionView.reloadData()
            
        }
        
        picker.dismiss(animated: true)
    }
}
