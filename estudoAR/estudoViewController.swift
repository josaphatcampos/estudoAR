//
//  estudoViewController.swift
//  estudoAR
//
//  Created by Josaphat Campos Pereira on 29/12/2017.
//  Copyright © 2017 Josaphat Campos Pereira. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class estudoViewController: UIViewController, ARSCNViewDelegate {

    var cenaAR:ARSCNView!
    let cena3D = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cenaAR = ARSCNView(frame: self.view.frame)
        self.cenaAR.delegate = self
        self.cenaAR.showsStatistics = true
        self.cenaAR.scene = cena3D
        self.view.addSubview(cenaAR)
        //self.cenaAR.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        cenaAR.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cenaAR.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        <#code#>
    }

}
