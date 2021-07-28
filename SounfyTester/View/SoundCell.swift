//
//  SoundCell.swift
//  SounfyTester
//
//  Created by Albert on 26/07/21.
//

import UIKit

class SoundCell: UITableViewCell {
    
    var playAction: ((String) -> Void)?
    var fileName = ""
    
    var playButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        self.accessoryView = playButton
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fill(image: String, name: String, description: String, fileName: String) {
        self.imageView?.image = UIImage(named: image)
        self.textLabel?.text = name
        self.detailTextLabel?.text = description
    }
    
    @objc func play() {
        playAction?(fileName)
    }
}
