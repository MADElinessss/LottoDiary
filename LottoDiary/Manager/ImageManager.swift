//
//  ImageManager.swift
//  LottoDiary
//
//  Created by 신정연 on 7/10/24.
//

import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    private init() { }
    
    func saveImageToDocumentDirectory(image: UIImage, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(nil)
                return
            }
            
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                completion(nil)
                return
            }
            
            do {
                try imageData.write(to: fileURL)
                DispatchQueue.main.async {
                    completion(fileName)
                }
            } catch {
                print("Error saving image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileURL = self.getDocumentDirectory().appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
