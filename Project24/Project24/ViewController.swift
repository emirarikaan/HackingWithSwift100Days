//
//  ViewController.swift
//  Project24
//
//  Created by Emir Arıkan on 4.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var currentDrawType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawTwin()
        
        // Do any additional setup after loading the view.
    }
    func drawTwin(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 170, y: 256)
            
            // T
            ctx.cgContext.move(to: CGPoint(x: -30, y: 1))
            ctx.cgContext.addLine(to: CGPoint(x: 30, y: 1))
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 60))
            
            // W
            ctx.cgContext.move(to: CGPoint(x: 40, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 60, y: 60))
            ctx.cgContext.move(to: CGPoint(x: 60, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 80, y: 0))
            ctx.cgContext.move(to: CGPoint(x: 80, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 60))
            ctx.cgContext.move(to: CGPoint(x: 100, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 0))
            
            // I
            ctx.cgContext.move(to: CGPoint(x: 130, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 130, y: 60))
            
            // N
            ctx.cgContext.move(to: CGPoint(x: 140, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 140, y: 60))
            ctx.cgContext.move(to: CGPoint(x: 140, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 60))
            ctx.cgContext.move(to: CGPoint(x: 180, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 0))
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
        
    }
    
    @IBAction func reDrawTabbed(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7{
            currentDrawType = 0
        }
        
        switch currentDrawType{
        case 0:
            drawTwin()
        case 1:
            drawEmote()
        case 2:
            drawRectangle()
        case 3:
            drawCircle()
        case 4:
            drawCheckerboard()
        case 5:
            drawRotatedSquares()
        case 6:
            drawLines()
        case 7:
            drawImagesAndText()
            
        default:
            break
            
        }
    }
    
    func drawEmote(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 66, y: 66, width: 400, height: 400)
                .insetBy(dx: 5, dy: 5)
            let eye1 = CGRect(x: 150, y: 200, width: 30, height: 40)
            let eye2 = CGRect(x: 350, y: 200, width: 30, height: 40)
            let mount = CGRect(x: 150, y: 330, width: 230, height: 3)
            
            ctx.cgContext.setFillColor(UIColor.clear.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.addEllipse(in: eye1)
            ctx.cgContext.addEllipse(in: eye2)
            ctx.cgContext.addRect(mount)
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = img
        
    }
    
    
    func drawRectangle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
       
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = img
    }
}

