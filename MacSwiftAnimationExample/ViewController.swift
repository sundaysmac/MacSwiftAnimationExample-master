//
//  ViewController.swift
//  MacSwiftAnimationExample
//
//  Created by cb_2018 on 2019/4/10.
//  Copyright © 2019 cfwf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let view2 = NSView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let toValue1 = NSMakeRect(10, 10, 100, 100)
        // 隐式动画 支持frame frameSize frameOrigin
        view2.frame = toValue1
        //更多隐式动画支持
        NSAnimationContext.current.allowsImplicitAnimation = true
        
        //2自动布局
//        self.view2.addConstraint(NSLayoutConstraint)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            self.view1.layoutSubtreeIfNeeded()
            //或者
            self.view1.window?.layoutIfNeeded()
        }, completionHandler: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
	let view1 = NSView()
    func groupAnimation() {
        let toValue1 = NSMakeRect(10, 10, 100, 100)
        let toVlaue2 = NSMakeRect(80, 100, 100, 100)
        NSAnimationContext.runAnimationGroup({ (NSAnimationContext) in
            self.view1.animator().frame = toValue1
        }) {
            NSAnimationContext.runAnimationGroup({ (NSAnimationContext) in
                self.view1.animator().frame = toVlaue2
            }, completionHandler: {
                
            })
        }
    }
    
    //副本层
    func addLayer1(){
    	let copiedLayer = CAReplicatorLayer()
        self.view.layer?.addSublayer(copiedLayer)
        //复制的个数
        copiedLayer.instanceCount = 3
        //复制时延时间隔
        copiedLayer.instanceDelay = 0.3
        //颜色的RGB递减
        copiedLayer.instanceRedOffset = -0.1
        copiedLayer.instanceBlueOffset = -0.1
        copiedLayer.instanceGreenOffset = -0.1
        //复制的层之间x,y,z轴的变换
        copiedLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        //创建自层
        let layer = CALayer()
        layer.frame = CGRect(x: 10, y: 10, width: 10, height: 100)
        layer.backgroundColor = NSColor.green.cgColor
        //子层动画
        let animation = CABasicAnimation(keyPath: "position.y")
//        animation.toValue = 200
        animation.toValue = (layer.position.y - CGFloat(arc4random()%100))
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 1000
        layer.add(animation, forKey: nil)
        //增加子层
        copiedLayer.addSublayer(layer)
    }
    
    /***
     *发射层
     *粒子系统包括粒子发射源控制系统CAEmitterLayer和粒子模型CAEmitterCell
     *CAEmitterLayer （emitterPostion发射源位置，emitterSize大小 birthRate每秒产生率
     *renderMode渲染模式 emiiterShape发射源形状 velocity速度）
     **
     *CAEmitterCell
     *（contents粒子内容【CGImageRef类型】 color颜色 velocity速度  scale缩放
     *spin 方向旋转 lifetime声明周期  acceleration[x,y,z三个方向加速度]）
     **/
    var emitterView: NSView?
    func emiiterAddLayer() {
        let rootLayer = self.view.layer
        //粒子源系统定义
        let snowEmitter = CAEmitterLayer()
        //异步绘制
        snowEmitter.drawsAsynchronously = true
        snowEmitter.name = "snowEmitter"
        snowEmitter.zPosition = 10.0
        snowEmitter.emitterPosition = CGPoint(x: 200, y: 200)
        snowEmitter.renderMode = .backToFront
        snowEmitter.emitterShape = .circle
        snowEmitter.emitterZPosition = -43.0
        snowEmitter.emitterSize = CGSize(width: 160, height: 160)
        snowEmitter.velocity = 20.3
        snowEmitter.emitterMode = .points
        snowEmitter.birthRate = 10
        //第一个粒子模型定义
        let snowFlakeCell = CAEmitterCell()
        snowFlakeCell.name = "snowFalkesCell"
        //粒子内容图像，必须是CGImageRef类型
        snowFlakeCell.contents = NSImage(named: "name.png")?.cgImage
        let colorRefSnowflakescell = CGColor(red: 0.7, green: 0.6, blue: 0.6, alpha: 0.5)
        snowFlakeCell.color = colorRefSnowflakescell
        snowFlakeCell.redRange = 0.9
        snowFlakeCell.blueRange = 0.8
        snowFlakeCell.greenRange = 0.7
        snowFlakeCell.redSpeed = 0.8
        snowFlakeCell.blueSpeed = 0.8
        snowFlakeCell.greenSpeed = 0.7
        snowFlakeCell.alphaRange = 0.9
        snowFlakeCell.alphaSpeed = 0.55
//        snowFlakeCell.magnificationFilter = kCAFilterTrilinear
        snowFlakeCell.scale = 0.7
        snowFlakeCell.scaleRange = 0.8
        snowFlakeCell.emissionLatitude = 1.75
        snowFlakeCell.emissionLongitude = 1.7
        snowFlakeCell.emissionRange = 3.49
        snowFlakeCell.lifetime = 9.0
        snowFlakeCell.lifetimeRange = 2.37
        snowFlakeCell.birthRate = 10.0
        snowFlakeCell.scaleSpeed = -0.23
        snowFlakeCell.velocity = 4.0
        snowFlakeCell.velocityRange = 2.0
        snowFlakeCell.xAcceleration = 1.0
        snowFlakeCell.yAcceleration = 2.0
        //第二个粒子模型
        let snowFlakeCell2 = CAEmitterCell()
        snowFlakeCell2.emissionRange = .pi
        snowFlakeCell2.lifetime = 10.0
        snowFlakeCell2.birthRate = 4.0
        snowFlakeCell2.velocity = 2.0
        snowFlakeCell2.velocityRange = 100.0
        snowFlakeCell2.yAcceleration = 300
        snowFlakeCell2.contents = NSImage(named: "baa.png")?.cgImage
//        snowFlakeCell2.magnificationFilter = kCAFilterNearest
        snowFlakeCell2.scale = 0.7
        snowFlakeCell2.scaleRange = 0.14
        snowFlakeCell2.spin = 0.38
        snowFlakeCell2.spinRange = 0
        //粒子发射源配置粒子模型
    	snowEmitter.emitterCells = [snowFlakeCell,snowFlakeCell2]
        rootLayer?.addSublayer(snowEmitter)
    }
    
    
}


//使用updateLayer实现绘制
class CustomView1: NSView {
    override var wantsUpdateLayer: Bool{
        return true
    }
    override func updateLayer() {
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.layer?.borderColor = NSColor.red.cgColor
    }
}
//渐变层
class CAGradientLayerVC: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.addLayer()
    }
    func addLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        gradientLayer.colors = [NSColor.green.cgColor,NSColor.red.cgColor,NSColor.cyan.cgColor,NSColor.purple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer?.addSublayer(gradientLayer)
    }
}

//隐式动画定义直线进度条
class CAShapLayerVC: NSViewController {
    var shapeLayer: CAShapeLayer!
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.addLayer()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.animationAction), userInfo: nil, repeats: true)
    }
    func addLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 20, y: 20))
        path.addLine(to: CGPoint(x: 200, y: 20))
        shapeLayer.path = path
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeColor = NSColor.green.cgColor
        self.view.layer?.addSublayer(shapeLayer)
    }
    
    func animationAction(_ sender: AnyObject) {
        if self.shapeLayer.strokeEnd < 1.0 {
            self.shapeLayer.strokeEnd += 0.1
        }else{
            self.timer.invalidate()
        }
    }
    
    //文本层
    func addTextLayer() {
        let textLayer = CATextLayer()
        textLayer.fontSize = 14.0
        //分辨率适配
        textLayer.contentsScale = NSScreen.main!.backingScaleFactor
        textLayer.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        textLayer.string = "text string"
        textLayer.alignmentMode = .center
        textLayer.backgroundColor = NSColor.clear.cgColor
        textLayer.foregroundColor = NSColor.black.cgColor
        self.view.layer?.addSublayer(textLayer)
    }
}
//分片层 CATitledLayer把层划分为小网格，每个网格内容单独加载c
class TitleView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    override func makeBackingLayer() -> CALayer {
        let titleLayer = CATiledLayer()
        titleLayer.tileSize = CGSize(width: 60, height: 60)
        titleLayer.delegate = self
        return titleLayer
    }
}
extension TitleView:CALayerDelegate{
    func draw(_ layer: CALayer, in ctx: CGContext) {
        let tileLayer = layer as! CATiledLayer
        let bounds = ctx.boundingBoxOfClipPath
        let row = floor(bounds.origin.x/tileLayer.tileSize.width)
        let col = floor(bounds.origin.y/tileLayer.tileSize.height)
        let r = CGFloat(arc4random()%255)/255.0
        let g = CGFloat(arc4random()%255)/255.0
        let b = CGFloat(arc4random()%255)/255.0
        let fillColor = NSColor(calibratedRed: r, green: g, blue: b, alpha: 1)
        ctx.setFillColor(fillColor.cgColor)
        ctx.fill(bounds)
        
    }
}
class CATitledLayerVC: NSViewController {
    fileprivate var scrollView: NSScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layerView = TitleView(frame: CGRect(x: 0, y: 0, width: 360, height: 360))
        self.scrollView.autohidesScrollers = true
        self.scrollView.documentView = layerView
    }
}

class CATransformLayerVC: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        self.transformLayerSetUp()
    }
    //变换层
    func transformLayerSetUp() {
        let rect = NSInsetRect(self.view.frame, 10, 10)
        let myView = NSView(frame: rect)
        myView.wantsLayer = true
        self.view.addSubview(myView)
        let cube = CATransformLayer()
        //z轴正对自己的前后两个面
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        let face1 = self.layerApplyTransform(ct)
        cube.addSublayer(face1)
        ct = CATransform3DMakeTranslation(0, 0, -50)
        let face2 = self.layerApplyTransform(ct)
        cube.addSublayer(face2)
        
        //x轴左右两个面
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, -(CGFloat)(M_PI_2), 0, 1, 0)
        let face3 = self.layerApplyTransform(ct)
        cube.addSublayer(face3)
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, (CGFloat)(M_PI_2), 0, 1, 0)
        let face4 = self.layerApplyTransform(ct)
        cube.addSublayer(face4)
        
        //y轴的上下两个面
        ct = CATransform3DMakeTranslation(0, 50, 0)
        ct = CATransform3DRotate(ct, (CGFloat)(M_PI_2), 1, 0, 0)
        let face5 = self.layerApplyTransform(ct)
        cube.addSublayer(face5)
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, -(CGFloat)(M_PI_2), 1, 0, 0)
        let face6 = self.layerApplyTransform(ct)
        cube.addSublayer(face6)
        
        //立方体的位置
        cube.position = CGPoint(x: 240, y: 240)
//        m34透视变换
        var pt = CATransform3DIdentity
        pt.m34 = -1/500
        myView.layer?.sublayerTransform = pt
        myView.layer?.addSublayer(cube)
    }
    
    func layerApplyTransform(_ transform: CATransform3D) -> CALayer {
        //创建立方体层
        let face  = CALayer()
        face.frame = CGRect(x: -50, y: -50, width: 100, height: 100)
        //应用随机颜色
        let red = CGFloat(arc4random()%255)/255.0
        let blue = CGFloat(arc4random()%255)/255.0
        let green = CGFloat(arc4random()%255)/255.0
        face.backgroundColor = NSColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        face.transform = transform
        return face
    }
}
