//
//  ViewController.swift
//  FlowLayout
//
//  Created by Karthi on 30/05/17.
//  Copyright © 2017 Tringapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UICollectionViewController{
   
    var photos : [UIImage] = [#imageLiteral(resourceName: "animationimage"),#imageLiteral(resourceName: "ball"),#imageLiteral(resourceName: "page1"),
    #imageLiteral(resourceName: "page3"),#imageLiteral(resourceName: "page4"),#imageLiteral(resourceName: "page2"),#imageLiteral(resourceName: "animationimage"),#imageLiteral(resourceName: "ball"),#imageLiteral(resourceName: "page1"),#imageLiteral(resourceName: "page3"),#imageLiteral(resourceName: "page4"),#imageLiteral(resourceName: "page2")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell" , for:indexPath)
        let photoImageView = cell.viewWithTag(100) as! UIImageView
        let photoLabel = cell.viewWithTag(101) as! UILabel
        photoImageView.image = photos[indexPath.row]
        photoImageView.frame.size.height = (cell.frame.size.height) - (photoLabel.frame.size.height)
        photoImageView.frame.size.width = cell.frame.size.width
        cell.backgroundColor = UIColor.green
        return cell
        
    }
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = self.collectionView?.contentOffset.y
        var y : CGFloat = 0
        for cell in (collectionView?.visibleCells)!
        {
            //let x = cell.viewWithTag(101)?.frame.origin.x
            //let width = cell.viewWithTag(101)?.bounds.width
            let height = cell.viewWithTag(101)?.bounds.height
            y = ((yOffset!-(cell.viewWithTag(101)?.frame.origin.y)!)/height!)*0.25
            print(y)
            //cell.viewWithTag(101)?.frame = CGRect(x: x!, y: y, width: width!, height: height!)
            cell.viewWithTag(101)?.frame.origin.y += y
            
            
        }
        
    }
    
}

extension ViewController : customLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.size, insideRect: boundingRect)
        return rect.size.height
    }
    
}





