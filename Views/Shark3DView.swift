import SwiftUI
import SceneKit

struct Shark3DView: UIViewRepresentable {
    let gender: SharkGender

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear

        if let scene = SCNScene(named: "shark.dae") {
            let sharkNode = scene.rootNode.clone()

            // Animate the shark to swim (basic swim motion)
            let rotate = SCNAction.rotateBy(x: 0, y: 0.3, z: 0, duration: 2)
            let reverse = SCNAction.rotateBy(x: 0, y: -0.3, z: 0, duration: 2)
            sharkNode.runAction(.repeatForever(.sequence([rotate, reverse])))

            // Tint shark with gender color
            let material = SCNMaterial()
            material.diffuse.contents = gender.color
            sharkNode.geometry?.materials = [material]

            scene.rootNode.addChildNode(sharkNode)
            sceneView.scene = scene
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

