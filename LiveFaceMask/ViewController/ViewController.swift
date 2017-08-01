//
//  ViewController.swift
//  DisplayLiveSamples
//
//

import Foundation
import AVFoundation
import UIKit

class ViewController: UIViewController, XMLParserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ParsingDidEndDelegate {
	
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
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		sessionHandler.session.stopRunning()
		
		sessionHandler.layer .removeFromSuperlayer()
		
		glView?.removeFromSuperview()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		sessionHandler.session.startRunning()
		sessionHandler.openSession()
		let layer = sessionHandler.layer
		let width = UIScreen.main.bounds.width;
		let height = UIScreen.main.bounds.height
		
		layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
		let scale = CGAffineTransform(scaleX: -1, y: 1)
		layer.setAffineTransform( scale)
		
		self.view.layer.addSublayer(layer)
		let item = collectionArray?.firstObject as? FaceMaskItem
		landmarkParser.parseDelegate = self
		landmarkParser.loadRssFeed(item?.landmakrFile)
	}
	
	
	func didEndLandmarksParsing(_ faceLandmarks: FaceLandmarks!) {
		
		DispatchQueue.main.async {
			let screenBounds = UIScreen.main.bounds
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
				let scale = CGAffineTransform(scaleX: -1, y: 1)
				self.glView?.layer.setAffineTransform(scale)
				self.view.addSubview(self.glView!)
				self.sessionHandler.glView = self.glView
			}
			
			self.sessionHandler.isFaceDetectionOff = false
			self.view.bringSubview(toFront: self.maskCollectionView)
		}
		
	}
	
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return (collectionArray?.count)!
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		sessionHandler.isFaceDetectionOff = true

		if selectedCell != nil {
			selectedCell?.layer.borderColor = UIColor.clear.cgColor
			selectedCell?.layer.borderWidth = 0
		}
		selectedCell = collectionView .cellForItem(at: indexPath)
		selectedCell?.layer.borderColor = UIColor.black.cgColor
		selectedCell?.layer.borderWidth = 3
		let item:FaceMaskItem = (collectionArray?.object(at: indexPath.row))! as! FaceMaskItem
//		print(item.landmakrFile)
		landmarkParser.loadRssFeed(item.landmakrFile)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskCell", for: indexPath);
		let item:FaceMaskItem = (collectionArray?.object(at: indexPath.row))! as! FaceMaskItem
		let imageView = cell.viewWithTag(1212) as! UIImageView
		let label = cell.viewWithTag(3131) as! UILabel
//		print("imageName:\(item.imageName)")
        imageView.image = UIImage(named: item.imageName)
		label.text = item.title
		return cell;
	}
	
}

