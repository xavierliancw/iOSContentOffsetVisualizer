//
//  ViewController.swift
//  iOSContentOffsetVisualizer
//
//  Created by Xavier Lian on 5/2/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: Properties
    
    @IBOutlet var offsetLbl: UILabel!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet var cv: UICollectionView!
    var cData = [Int]()
    let REUSEID = "cell"
    var timer: Timer?
    var currentHeldBt: UIButton?
    
    //MARK: UI Business

    override func viewDidLoad()
    {
        super.viewDidLoad()
        for bt in bts
        {
            bt.layer.borderColor = UIColor.blue.cgColor
            bt.layer.borderWidth = 1
        }
        for x in 0 ..< 100
        {
            cData.append(x)
        }
        setupCV()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        updateLbl()
    }
    
    //MARK: Functions
    
    @IBAction func decrementY(_ sender: Any)
    {
        cv.contentOffset.y -= 1
        updateLbl()
    }
    @IBAction func incrementY(_ sender: Any)
    {
        cv.contentOffset.y += 1
        updateLbl()
    }
    @IBAction func decrementX(_ sender: Any)
    {
        cv.contentOffset.x -= 1
        updateLbl()
    }
    @IBAction func incrementX(_ sender: Any)
    {
        cv.contentOffset.x += 1
        updateLbl()
    }
    
    func updateLbl()
    {
        offsetLbl.text = "CurrentOffset: \(cv.contentOffset)"
    }
    
    @IBAction func buttonDown(_ sender: UIButton)
    {
        currentHeldBt = sender
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                     selector: #selector(rapidFire), userInfo: nil, repeats: true)
    }
    
    @IBAction func buttonUp(_ sender: UIButton)
    {
        sender.sendActions(for: .editingDidEndOnExit)
        timer?.invalidate()
        currentHeldBt = nil
    }
    
    @objc func rapidFire()
    {
        currentHeldBt?.sendActions(for: .editingDidEndOnExit)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return cData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSEID, for: indexPath)
        if let cast = cell as? CellMang, 0 ..< cData.count ~= indexPath.item
        {
            cast.label.text = String(describing: cData[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        updateLbl()
    }
    
    private func setupCV()
    {
        cv.delegate = self
        cv.dataSource = self
        cv.register(CellMang.self, forCellWithReuseIdentifier: REUSEID)
    }
}

//MARK: - Custom Collection Cell

class CellMang: UICollectionViewCell
{
    //MARK: Properties
    
    var label = UILabel()
    
    //MARK: UI Business
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse()
    {
        label.text = ""
    }
    
    func setup()
    {
        backgroundColor = .blue
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        label.textAlignment = .center
    }
}
