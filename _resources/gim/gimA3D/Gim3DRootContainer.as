package gim.gimA3D 
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Debug;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.AxisAlignedSprite;
	import alternativa.engine3d.objects.Decal;
	import alternativa.engine3d.objects.LOD;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import gim.maps.Map;
	import gim.maps.structs.Struct3D;
	//import gim.shapes.GimBall;
	/**
	 * ...
	 * @author Gamba
	 */
	public class Gim3DRootContainer extends Sprite
	{
		public var rootContainer:Object3D;
		public var placeFocusMaterial:Material;
		public var camera:Camera3D;
		public var cameraContainer:Object3D;
		public var cameraRotateZContainer:Object3D;
		public var cameraRotateXContainer:Object3D;
		public var cameraMoveContainer:Object3D;
		
		public var stage3D:Stage3D;
		public var shadow:DirectionalLightShadow;
		private var directionalLight:DirectionalLight;
		
		//public var offsetX:Number = 1200;
		//public var offsetY:Number = -1000;
		public var defaultCameraDistance:Number = 800;
		public var maxCameraDistance:Number;
		public var minCameraDistance:Number;
		public var defaultRotationX:Number = 0;
		public var defaultRotationZ:Number = 0;
		public var shadowDebug:Number = 0;
		public var placeFocusColor:uint = 0;
		private var viewWidth:Number;
		private var viewHeight:Number;
		
		private var _cameraDistance:Number;
		public var pathFrame:WireFrame;
		private var _onCompleteHandler:Function;
		
		public function Gim3DRootContainer(W:Number = 800,H:Number = 600,onCompleteHandler:Function = null) 
		{
			viewWidth = W;
			viewHeight = H;
			_onCompleteHandler = onCompleteHandler;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
			
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			rootContainer = new Object3D();
			cameraContainer = new Object3D();
			cameraRotateXContainer = new Object3D();
			cameraRotateZContainer = new Object3D();
			cameraMoveContainer = new Object3D();
			
			//add camera
			camera = new Camera3D(200, 160000);
			camera.view = new View(viewWidth, viewHeight, false, 0, 0, 16);
			addChild(camera.view);
			camera.view.hideLogo();
			camera.rotationX = -90 * Math.PI / 180;				//camera放在y轴上,且正对原点,cameraDistance即为其y值
			cameraDistance = defaultCameraDistance;
			//addChild(camera.diagram); //调试信息面板
			//camera.fov = Math.PI/8;
			//camera.debug = true;
			//camera.addToDebug(Debug.BOUNDS, Object3D);
			
			//add containers
			cameraContainer.addChild(camera);
			cameraRotateXContainer.addChild(cameraContainer);
			cameraRotateZContainer.addChild(cameraRotateXContainer);
			cameraMoveContainer.addChild(cameraRotateZContainer);
			rootContainer.addChild(cameraMoveContainer);
			cameraRotateXContainer.rotationX = defaultRotationX;
			cameraRotateZContainer.rotationZ = defaultRotationZ;
			
			// Light sources
			var ambientLight:AmbientLight = new AmbientLight(0x333333);
			rootContainer.addChild(ambientLight);
			directionalLight = new DirectionalLight(0xffffff);
			directionalLight.intensity = 0.8;
			directionalLight.lookAt(0.2, 1, -1);
			//directionalLight.lookAt(-0.8, 1, -0.8);
			rootContainer.addChild(directionalLight);
			
			// Shadow
			//shadow = new DirectionalLightShadow(1400 * 2, 1000 * 2, -1600, 800, 2048, 1);
			shadow = new DirectionalLightShadow(1, 1, 1, 1, 2048,1);
			shadow.biasMultiplier = 0.993;
//			directionalLight.shadow = shadow;
			shadow.debug = Boolean(shadowDebug == 1);
			
			//focus material
			placeFocusMaterial = Struct3D.getStandardMaterial(placeFocusColor);
			var box:Box = new Box(0, 0, 0, 1, 1, 1, false, placeFocusMaterial);
			addChild3D(box);
			
			//path frame
			pathFrame = WireFrame.createLineStrip(Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(0, 0, 300)]), 0xff0033, 0.8, 4);
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
			
			_onCompleteHandler();
		}
		
		/**
		 * 显卡建立,3D环境建立
		 * */
		private function onContextCreate(e:Event):void
		{
			//相当于代理模式,以免addChild3D()函数找不到rootContainer的问题
			if(obj3DTempArr)
			{
				for each(var obj3D:Object3D in obj3DTempArr)
				{
					addChild3D(obj3D);
				}
			}
			
			uploadResources(rootContainer);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			//camera.view.width = _width;
			//camera.view.height = _height;
			camera.render(stage3D);
		}
		
		/**
		 * 上传资源到显卡中
		 * */
		public function uploadResources(obj3D:Object3D):void
		{
			for each (var resource:Resource in obj3D.getResources(true))
			{
				resource.upload(stage3D.context3D);
			}
			trace("- Gim3DRootContainer 196, uploadResources");
		}
		
		/**
		 * 添加一个Object3D对象,并将资源上传到显卡,和将其添加到阴影中
		 * */
		public function addChild3D(obj3D:Object3D):void
		{
			if(!rootContainer)
			{
				if(!obj3DTempArr) obj3DTempArr = [];
				obj3DTempArr.push(obj3D);
			}
			else
			{
				rootContainer.addChild(obj3D);
				shadow.addCaster(obj3D);
			}
		}
		private var obj3DTempArr:Array;
		
		/**
		 * 重置
		 * */
		public function reset():void 
		{
			//backgroundDistance -= 0.01;
			//background.y = _cameraDistance * backgroundDistance;
			//AppConfig.instance.log(backgroundDistance.toString());
			
			Tweener.removeTweens(cameraContainer);
			Tweener.removeTweens(cameraMoveContainer);
			Tweener.removeTweens(cameraRotateXContainer);
			Tweener.removeTweens(cameraRotateZContainer);
			
			cameraDistance = defaultCameraDistance;
			cameraRotateXContainer.rotationX = defaultRotationX;
			cameraRotateZContainer.rotationZ = defaultRotationZ;
			
			offsetPoint = offsetPoint;
		}
		
		/**
		 * 添加背景图片
		 * */
		public function addBackground(backgroundUrl:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundImgLoad);
			loader.load(new URLRequest(backgroundUrl));
		}
		
		/**
		 * 背景图片载入监听
		 * */
		private function onBackgroundImgLoad(e:Event):void
		{
			var bitmap:Bitmap = e.currentTarget.content as Bitmap;
			var iconMaterial:TextureMaterial = new TextureMaterial(new BitmapTextureResource(bitmap.bitmapData, true));
			iconMaterial.alphaThreshold = 1;
			
			//默认方法,尺寸乘以11,距离直接乘以最合适的7.05,数学方法应该是用camera.fov和viewWidth,viewHeight来计算background的大小和位置
			background = new Sprite3D(viewWidth * 11, viewHeight * 11,iconMaterial);
			cameraContainer.addChild(background);
			background.y = _cameraDistance * backgroundDistance;
			
			//另外的方法,待考
			//ar diagnal:Number = 2*10000*Math.tan(  camera.fov /2);
			//var angle:Number = Math.atan(camera.view.height/camera.view.width);
			//planeBG = new Plane2(  diagnal*Math.cos(angle)    ,  diagnal*Math.sin(angle) ,16 ,10 );
			//planeBG.rotationZ = Math.PI;		
			//planeBG.x =  0 ;
			//planeBG.y =  500 ;
			//planeBG.z =  150000 ;
			//var background:Sprite3D = new Sprite3D(diagnal*Math.cos(angle), diagnal*Math.sin(angle),iconMaterial);
			
			uploadResources(background);
		}
		public	var background:Sprite3D;
		private var backgroundDistance:Number = 8.81;
		
		public function get cameraDistance():Number 
		{
			return _cameraDistance;
		}
		
		public function set cameraDistance(distance:Number):void 
		{
			if(distance >= minCameraDistance && distance <= maxCameraDistance)
			{
				_cameraDistance = distance;
				Tweener.removeTweens(cameraContainer);
				Tweener.addTween(cameraContainer,{y:- distance,time:1});
				
				AppConfig.instance.log("- GimMap3DRootContainer,239,cameraDistance:" + distance);
			}
		}
		
		/**
		 * 设定偏移点
		 * */
		public function set offsetPoint(value:Point):void
		{
			this._offsetPoint = value;
			cameraMoveContainer.x = this._offsetPoint.x;
			cameraMoveContainer.y = - this._offsetPoint.y;
			shadow.centerX = this._offsetPoint.x;
			shadow.centerY = - this._offsetPoint.y;
			shadow.width = this._offsetPoint.x * 2;
			shadow.height = this._offsetPoint.y * 2;
			shadow.nearBoundPosition = - this._offsetPoint.x ;
			shadow.farBoundPosition = this._offsetPoint.x ;
		}
		
		public function get offsetPoint():Point
		{
			return this._offsetPoint;
		}
		private var _offsetPoint:Point;
		
	}

}