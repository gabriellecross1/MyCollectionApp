//
//  SecondViewController.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 14/01/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import UIKit
import AVFoundation
import Vision


class SecondViewController: UIViewController, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDataSource, UITableViewDelegate,ImageDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func showImagePicker(_ sender: UIButton) {
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let targetView = (MainStoryBoard.instantiateViewController(identifier: "ImageCapture")as? ImageCapture)!
        targetView.delegate = self
        navigationController?.pushViewController(targetView,animated: true)
    }
    @IBOutlet weak var GameTableView: UITableView!
    
    var games: [BoardGame] = []
    var imageCapture: ImageCapture!
    var resultImage: CGImage!
    var bbgapi: BGGAPI!
    var gameIds:[String]!
    let cellReuseIdentifier = "cell"
    var db:OpaquePointer!
    var returnImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        GameTableView.dataSource = self
        GameTableView.delegate = self
        GameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        db = Database.openDatabase()!
        Database.initializeDataModel(connection: db)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func onImageReady(image: UIImage) {
        
        let result = GetTextFromImage(image: image)
        SearchForGame(gameName: result)
    }
    
    //Tables
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let targetView = (MainStoryBoard.instantiateViewController(identifier: "DetailsVM")as? DetailsVM)!
        targetView.game = games[indexPath.item]
        
        navigationController?.pushViewController(targetView,animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = games[indexPath.item].name
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if(searchBar.text!.containsEmoji)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a vaild game name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            SearchForGame(gameName: searchBar.text!)
        }
    }
    
    func SearchForGame(gameName: String)  {
        
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.GetGameDetails(gameName: gameName)
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.games.sort { $0.levenshteinDistanceScore > $1.levenshteinDistanceScore }
            self.UpdateUi()
        }
    }
    
    private func GetGameDetails(gameName:String)
    {
        games = []
        bbgapi = BGGAPI()
        gameIds = bbgapi.GetGameIds(gameName: gameName)
        if gameIds.count == 0
        {
            let alert = UIAlertController(title: "Error", message: "No Games Found For : " + gameName, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            for id in gameIds {
                var game = bbgapi.GetGame(gameId:id)
                game.levenshteinDistanceScore = game.name.levenshteinDistanceScore(to: gameName)
                games.append(game)
            }
            print("done")
        }
    }
    
    private func UpdateUi()
    {
        GameTableView.reloadData()
    }
    
    private func GetTextFromImage(image:UIImage)->String
    {
        var ciImage = CIImage(image: image)!
        ciImage = GrayScaleImage(image: ciImage)
        ciImage = ReduceNoiseImage(image: ciImage)
        
        let image =  convertCIImageToCGImage(inputImage: ciImage)
        var topCandidateName :String = ""
        let requestHandler = VNImageRequestHandler(cgImage: image as! CGImage, options: [:])
        let request = VNRecognizeTextRequest{ (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            for currentObservation in observations
            {
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    topCandidateName = recognizedText.string
                }
            }
        }
        request.recognitionLevel = .accurate
        try? requestHandler.perform([request])
        return topCandidateName
    }
    
    private func GrayScaleImage(image: CIImage) -> CIImage
    {
        return image.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 5])
    }
    
    private func ReduceNoiseImage(image: CIImage)-> CIImage
    {
        return image.applyingFilter("CINoiseReduction", parameters: ["inputNoiseLevel": 0.02, "inputSharpness": 0.40])
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
}


extension String {
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {
        
        var firstString = self
        var secondString = string
        
        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)
        
        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        
        let lowestScore = max(firstString.count, secondString.count)
        
        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }
        
        return 0.0
    }
}
extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
    
}
