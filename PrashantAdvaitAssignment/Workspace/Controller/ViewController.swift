//
//  ViewController.swift
//  PrashantAdvaitAssignment
//
//  Created by Raman choudhary on 10/05/24.
//

import UIKit

class ViewController: UIViewController {
    // ViewController global variables
    var imageList:[ImageListModel]?
    let cellIdentifier = "ImagesCollectionCell"
    
    // ViewController IBoutlets
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        self.getImagedata()
    }
    
    // Func to get images list data by api call
    func getImagedata(){
        APIService().fetchData { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let imagesData = try decoder.decode([ImageListModel].self, from: data)
                        self.imageList = imagesData
                        self.ImagesCollectionView.reloadData()
                    } catch {
                        print("Error decoding JSON: \(error)")
                        
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // Func to set collection view data source and delegate
    func setCollectionView(){
        self.ImagesCollectionView.delegate = self
        ImagesCollectionView.dataSource = self
        ImagesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    // Collection view data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImagesCollectionCell else{
            return UICollectionViewCell()
        }
        if let imageData = imageList?[indexPath.row].thumbnail{
            
            // construct image url by using this formula imageURL = domain + "/" + basePath + "/0/" + key
            let imageUrlString = "\(imageData.domain ?? "")/\(imageData.basePath ?? "")/0/\(imageData.key ?? "")"
            
            // cancel image loading if user scroll to new visible cells
            CacheManager.shared.cancelImageLoad(forKey: imageData.basePath ?? "")
            
            if let imageUrl = URL(string: imageUrlString){
                CacheManager.shared.fetchImage(from: imageUrl, key: imageData.basePath ?? "") { image, error in
                    DispatchQueue.main.async {
                        // Check if the cell is still visible and update the image view
                        if let cellIndexPath = collectionView.indexPath(for: cell), cellIndexPath == indexPath {
                            if error == nil {
                                cell.imageView.image = image
                                cell.failedLabel.text = ""
                            }else{
                                cell.imageView.image = nil
                                cell.failedLabel.text = "Fail to load"
                            }
                            
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
   
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell_width = (UIScreen.main.bounds.width - 20) / 3
        return CGSize(width: cell_width, height: cell_width )
    }
}

