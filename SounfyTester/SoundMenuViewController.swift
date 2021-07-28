//
//  ViewController.swift
//  SounfyTester
//
//  Created by Albert on 20/07/21.
//

import UIKit
import Soundfy

class SoundMenuViewController: UIViewController {
    
    let sounds = [Sound(imageName: "lion-head", name: "Game Over", description: "Toca som", fileName: "GameOver")]
    let backgrounds = [Sound(imageName: "lama-head", name: "Background", description: "Toca musica", fileName: "MenuBackground")]
    let sections = ["Sounds", "Background"]
    
    let soundManager = SoundManager.shared()
    let backgroundPlayer = BackgroundPlayer.shared()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var isSoundMuted: Bool {
        soundManager?.isSoundEffectMuted ?? false
    }
    
    var isMusicMuted: Bool {
        soundManager?.isBackgroundMuted ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtons()
        setupConstraints()
        self.title = "Animal Sounds"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(SoundCell.self, forCellReuseIdentifier: "SoundCell")
    }
    
    private func setupBarButtons() {
        let soundButton = UIBarButtonItem(image: UIImage(systemName: isSoundMuted ?  "speaker.2.fill" : "speaker.slash.fill"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(muteSound))
        let musicButton = UIBarButtonItem(image: UIImage(systemName: "music.note"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(muteMusic))
        navigationItem.setRightBarButtonItems([soundButton, musicButton],
                                              animated: true)
    }

    private func setupConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func presentAlert() {
        let alertVc = UIAlertController(title: "O som está mudo",
                                        message: "bota pra tocar dj",
                                        preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVc, animated: true, completion: nil)
    }
    
    func playSound(named name: String) {
        if isSoundMuted {
            presentAlert()
        }
        let player = SoundfyPlayer()
        player.playSound(name)
    }
    
    func playMusic(named name: String) {
        if isMusicMuted {
            presentAlert()
        }
        backgroundPlayer?.playSound(name)
    }
    
    @objc func muteSound() {
        navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: isSoundMuted ? "speaker.2.fill" : "speaker.slash.fill")
        soundManager?.setMutedSoundEffects(!isSoundMuted)
    }

    @objc func muteMusic() {
        soundManager?.setMutedBackground(!isMusicMuted)
    }
}

extension SoundMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? sounds.count : backgrounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell") as? SoundCell else {
            return UITableViewCell()
        }
        
        let sound = indexPath.section == 0 ? sounds[indexPath.row] : backgrounds[indexPath.row]
        
        cell.fill(image: sound.imageName, name: sound.name, description: sound.description, fileName: sound.fileName)
        
        cell.playAction = indexPath.section == 0 ? playSound(named:) : playMusic(named:)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let sound = sounds[indexPath.row]
            playSound(named: sound.fileName)
        case 1:
            let music = backgrounds[indexPath.row]
            playMusic(named: music.fileName)
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
