//
//  ViewController.swift
//  PhotoMaster
//
//  Created by TAIGA ITO on 2024/04/25.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //カメラボタンを押した時に呼ばれるメソッド
    @IBAction func onTappedCameraButton() {
        presentPickerController(sourceType: .camera)
    }

    //アルバムボタンを押した時に呼ばれるメソッド
    @IBAction func onTappedAlbumButton() {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func onTappedTextButton() {
        if photoImageView.image != nil {
            photoImageView.image = drawText(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedIllustButton() {
        if photoImageView.image != nil {
            photoImageView.image = drawMaskImage(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedUploadButton() {
        if photoImageView.image != nil {
            //共有するアイテムを設定
            let activityVC = UIActivityViewController(activityItems: [photoImageView.image!, "#PhotoMaster"], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        } else {
            print("画像がありません")
        }
    }
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as! UIImage
        let size = CGSize(width: image.size.width / 8, height: image.size.height / 8)
        let resizedImage = UIGraphicsImageRenderer(size: size).image {_ in
            image.draw(in: CGRect(origin: .zero, size: size))
            photoImageView.image = image
        }
    }
    
    func drawText(image: UIImage) -> UIImage {
        //テキストの内容の設定
        let text = "LifeisTech!"
        
        //textFontAttributes: 文字の特性 [フォントとサイズ、カラー、スタイル] の設定
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 120)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        
        //グラフィックスコンテキスト生成、編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        //定義　CGRect(x: [左からのx座標]px, y: [上からのy座標]px, width: [横の長さ]px, height: [縦の長さ]px)
        let margin: CGFloat = 5.0
        let textRect: CGRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
        
        //textRectで指定した範囲にtextFontAttributesにしたがってtextを書き出す
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        //グラフィックスコンテキストの画像取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func drawMaskImage(image: UIImage) -> UIImage {
        //マスク画像（保存場所: photoMaster > Assets.xcassets)の設定
        let maskImage = UIImage(named: "furo_ducky")!
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let margin: CGFloat = 50.0
        let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin,
                              y: image.size.height - maskImage.size.height,
                              width: maskImage.size.width, height: maskImage.size.height)
        
        maskImage.draw(in: maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

