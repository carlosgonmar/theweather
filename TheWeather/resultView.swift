//
//  resultView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 5/10/22.
//

import UIKit

@IBDesignable
class resultView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        
        backgroundColor = UIColor.red
        
    }
    private func create(){
        
        let image: UIImageView = UIImageView(image: UIImage(named: "Rain"))
        self.addSubview(image)
        
        
    }
    private func createRainRecord(){
        
        let image: UIImageView = UIImageView(image: UIImage(named: "Rain"))
        self.addSubview(image)
        
        
    }

}
