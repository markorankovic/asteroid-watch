import SceneKit
import SpriteKit

func getTextNode(text: String, fontSize: CGFloat, font: UIFont) -> SCNPlane {
    let size = CGSize(width: fontSize * CGFloat(text.count), height: fontSize)
    let plane = SCNPlane(width: size.width, height: size.height)
    let view = SKView(frame: .init(origin: .zero, size: .init(width: size.width, height: size.height)))
    let scene = SKScene(size: view.frame.size)
    let textNode = SKLabelNode(text: text)
    textNode.fontSize = fontSize
    textNode.color = .black
    textNode.fontName = font.fontName
    scene.addChild(textNode)
    view.presentScene(scene)
    let mat = SCNMaterial()
    mat.diffuse.contents = view.texture(from: scene)
    plane.materials.append(mat)
    return plane
}

//getTextNode(text: "ioerngo", fontSize: 10, font: UIFont(name: "COPPERPLATE", size: 10))

let text = "ioerngo"
let fontSize = 10
let size = 10
let font = UIFont(name: "COPPERPLATE", size: size)

let size = CGSize(width: fontSize * CGFloat(text.count), height: fontSize)
let plane = SCNPlane(width: size.width, height: size.height)
let view = SKView(frame: .init(origin: .zero, size: .init(width: size.width, height: size.height)))
let scene = SKScene(size: view.frame.size)
let textNode = SKLabelNode(text: text)
textNode.fontSize = fontSize
textNode.color = .black
textNode.fontName = font.fontName
scene.addChild(textNode)
view.presentScene(scene)
let mat = SCNMaterial()
mat.diffuse.contents = view.texture(from: scene)
plane.materials.append(mat)

scene
