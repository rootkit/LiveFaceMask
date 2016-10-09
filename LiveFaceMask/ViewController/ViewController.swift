//
//  ViewController.swift
//  DisplayLiveSamples
//
//

import Foundation
import AVFoundation
import UIKit

class ViewController: UIViewController, NSXMLParserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ParsingDidEndDelegate {
	
	var faceMaskArray = NSMutableArray()
	let sessionHandler = SessionHandler()
	var collectionArray:NSMutableArray?
	var selectedCell:UICollectionViewCell?
	var glView:OGLView?
	var isGLViewAdded = false
	let landmarkParser = LandmaskXMLParser()
	@IBOutlet weak var preview: UIView!
	
	@IBOutlet var maskCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let xmlparser = XmlParser()
		xmlparser.loadRssFeed("FaceMask")
		faceMaskArray = (xmlparser.faceMaskArray.firstObject as! FaceMaskCategories).faceMaskItemArray
		collectionArray = faceMaskArray

	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		sessionHandler.session.stopRunning()
		
		sessionHandler.layer .removeFromSuperlayer()
		
		glView?.removeFromSuperview()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
//		sessionHandler.session.startRunning()
		sessionHandler.openSession()
		let layer = sessionHandler.layer
		let width = UIScreen.mainScreen().bounds.width;
		let height = UIScreen.mainScreen().bounds.height
		
		layer.frame = CGRectMake(0, 0, width, height)
		let scale = CGAffineTransformMakeScale(-1, 1)
		layer.setAffineTransform( scale)
		
		self.view.layer.addSublayer(layer)
		let item = collectionArray?.firstObject as? FaceMaskItem
		landmarkParser.parseDelegate = self
		landmarkParser.loadRssFeed(item?.landmakrFile)
	}
	
	
	func didEndLandmarksParsing(faceLandmarks: FaceLandmarks!) {
		
		dispatch_async(dispatch_get_main_queue()) {
			let screenBounds = UIScreen.mainScreen().bounds
//			print(faceLandmarks.maskImageName)
			if self.isGLViewAdded
			{
				self.glView?.setupVBOs(faceLandmarks.maskImageName, withLandmaskArray: faceLandmarks.landmarksArray)
			}
			else
			{
				self.isGLViewAdded = true
				
				self.glView = OGLView(frame:screenBounds, imageName:
					faceLandmarks.maskImageName, landmarkArray:  faceLandmarks.landmarksArray)
				let scale = CGAffineTransformMakeScale(-1, 1)
				self.glView?.layer.setAffineTransform(scale)
				self.view.addSubview(self.glView!)
				self.sessionHandler.glView = self.glView
			}
			
			self.sessionHandler.isFaceDetectionOff = false
			self.view.bringSubviewToFront(self.maskCollectionView)
		}
		
	}
	
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return (collectionArray?.count)!
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		sessionHandler.isFaceDetectionOff = true

		if selectedCell != nil {
			selectedCell?.layer.borderColor = UIColor.clearColor().CGColor
			selectedCell?.layer.borderWidth = 0
		}
		selectedCell = collectionView .cellForItemAtIndexPath(indexPath)
		selectedCell?.layer.borderColor = UIColor.blackColor().CGColor
		selectedCell?.layer.borderWidth = 3
		let item:FaceMaskItem = (collectionArray?.objectAtIndex(indexPath.row))! as! FaceMaskItem
//		print(item.landmakrFile)
		landmarkParser.loadRssFeed(item.landmakrFile)
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MaskCell", forIndexPath: indexPath);
		let item:FaceMaskItem = (collectionArray?.objectAtIndex(indexPath.row))! as! FaceMaskItem
		let imageView = cell.viewWithTag(1212) as! UIImageView
		let label = cell.viewWithTag(3131) as! UILabel
//		print("imageName:\(item.imageName)")
		imageView.image = UIImage(imageLiteral: item.imageName)
		label.text = item.title
		return cell;
	}
	
}

