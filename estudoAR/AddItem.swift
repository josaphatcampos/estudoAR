//
//  Dragao.swift
//  estudoAR
//
//  Created by Josaphat Campos Pereira on 30/12/2017.
//  Copyright © 2017 Josaphat Campos Pereira. All rights reserved.
//

import SceneKit
import QuartzCore

class AddItem{
    var position = SCNVector3()
    var rotation = SCNVector3()
    var scale = SCNVector3(1.0, 1.0, 1.0)
    
    var cena = SCNScene()
    var modelo = SCNNode()
    
    init(){
        
    }
    
    func addObjNode(nodePai:SCNNode){
        nodePai.addChildNode(modelo)
    }
    
    func carregaModelo(nomeCena:String, nomeModelo:String){
        cena = SCNScene(named: nomeCena)!
        modelo.position = position
        let node = cena.rootNode.childNode(withName: nomeModelo, recursively: true)!
        
        modelo.addChildNode(node)
    }
    
    func giraItem(){
        let turnAction = SCNAction.rotateBy(x: 0, y: CGFloat(Double.pi), z: 0, duration: 3.0)
        let keepTurn = SCNAction.repeatForever(turnAction)
        modelo.runAction(keepTurn)
    }
}
