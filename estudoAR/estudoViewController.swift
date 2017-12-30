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

class estudoViewController: UIViewController, ARSCNViewDelegate, SCNSceneRendererDelegate {

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
        
        //iluminacao
        iluminacao(position: SCNVector3(0, 0.5, 0), node: cenaAR.scene.rootNode)
        //add modelos
        let dragao = AddItem()
        dragao.position = SCNVector3(0.8, 0, -0.5)
        dragao.scale = SCNVector3(2.0, 2.0, 2.0)
        dragao.carregaModelo(nomeCena: "dragao.dae", nomeModelo: "parentDragao")
        dragao.addObjNode(nodePai: cenaAR.scene.rootNode)
        
        let felpudo = AddItem()
        felpudo.position = SCNVector3(-2.0, 0, -5.0)
        felpudo.carregaModelo(nomeCena: "felpudoFlappy.dae", nomeModelo: "objetoFelpudo")
        felpudo.addObjNode(nodePai: cenaAR.scene.rootNode)
        
        //toque
        let toque = UITapGestureRecognizer(target: self, action: #selector(addObject))
        self.cenaAR.addGestureRecognizer(toque)
        
    }
    
    @objc func addObject(recognizer:UITapGestureRecognizer){
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation  = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitResults.isEmpty{
            guard let hit = hitResults.first else{
                return
            }
            
            //addLuz
            iluminacao(position: SCNVector3(0, 0, 0), node: sceneView.scene.rootNode)
            
            let positionX = hit.worldTransform.columns.3.x
            let positionY = hit.worldTransform.columns.3.y
            let positionZ = hit.worldTransform.columns.3.z
            
            //add modelos
            let dragao = AddItem()
            dragao.position = SCNVector3(positionX, positionY, positionZ)
            dragao.carregaModelo(nomeCena: "dragao.dae", nomeModelo: "parentDragao")
            
            dragao.addObjNode(nodePai: sceneView.scene.rootNode)
        }
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

    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !(anchor is ARPlaneAnchor){
            return
        }
        //add plano
        let myplaneAnchor =  anchor as! ARPlaneAnchor
        let widthPlane = CGFloat(myplaneAnchor.extent.x)
        let deepPlane = CGFloat(myplaneAnchor.extent.z)
        let myplane = SCNPlane(width: widthPlane, height: deepPlane)
        let nodePlane = SCNNode(geometry: myplane)
        nodePlane.position = SCNVector3(myplaneAnchor.center.x, 0, myplaneAnchor.center.z)
        nodePlane.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0, 0)
        node.addChildNode(nodePlane)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let stimate = self.cenaAR.session.currentFrame?.lightEstimate
        
        if stimate == nil {
            return
        }
        
        updateLightIntensity(intensity: (stimate?.ambientIntensity)!)
        
        
    }
    
    func iluminacao(position:SCNVector3, node:SCNNode, intensity:CGFloat = 0){
        let luz = SCNLight()
        luz.type = .ambient
        
        let nodeLuz = SCNNode()
        nodeLuz.name = "luzAmbiente"
        nodeLuz.light = luz;
        nodeLuz.position = position
        if (intensity != 0){
            nodeLuz.light?.intensity = intensity
        }
        
        
        node.addChildNode(nodeLuz)
    }
    
    func updateLightIntensity(intensity:CGFloat){
        if let nodeLuz = cenaAR.scene.rootNode.childNode(withName: "luzAmbiente", recursively: true) {
            nodeLuz.light?.intensity = intensity
        }
    }

}
