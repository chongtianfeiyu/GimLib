package gim.maps.structs
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Decal;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import gim.gimA3D.Gim3DRootContainer;
	import gim.gimA3D.GimPolygon;
	import gim.gimA3D.GimPolygon3D;
	import gim.maps.models.Model;
	import gim.maps.models.ModelFloor;
	import gim.maps.models.ModelPlace;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class Place extends Struct3D
	{
		public var model:ModelPlace;
		public var position:Point;
		
		public function Place($model:ModelPlace, $height:Number = 12)
		{
			this.model = $model;
			this.spacePoints = getSpacePoints(model.area);
			this.polygon = new GimPolygon(spacePoints);
			this.polygon3D = new GimPolygon3D(polygon, $height, true, getStandardMaterial(uint(model.color)));
			this.position = polygon3D.centerPoint;
			this.addChild(polygon3D);
			if(model.textMapping == "True")
				addText(model.number);
				
			//add a sphere loacled the centerPoint of polygon3D
			//var sphere:GeoSphere = new GeoSphere(3, 2, false, getStandardMaterial(uint(model.color)));
			//addChild(sphere);
			//sphere.x = polygon3D.centerPoint.x;
			//sphere.y = - polygon3D.centerPoint.y;
			//sphere.z = $height + 2;
			
			this.addEventListener(MouseEvent3D.CLICK, onMouseClick);
		}
		
		public function addText(text:String):void
		{
			var label:TextField = new TextField();
			label.width = label.height = 0;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = text;
			var bitmapData:BitmapData = new BitmapData(label.width, label.height, true, 0x00000000);
			bitmapData.draw(label);
			
			var textMaterial:TextureMaterial = new TextureMaterial(new BitmapTextureResource(bitmapData, true));
			textMaterial.alphaThreshold = 1;
			//var textPlan:Plane = new Plane(bitmapData.width, bitmapData.height, 1, 1, false, false, null, textMaterial);
			var textPlan:Plane = new Plane(1, 1, 1, 1, false, false, null, textMaterial);
			addChild(textPlan);
			textPlan.x = polygon3D.centerPoint.x + Number(model.textX);
			textPlan.y = -polygon3D.centerPoint.y - Number(model.textY);
			textPlan.z = polygon3D._height + 1;
			textPlan.rotationZ = - Number(model.textRotate) * Math.PI/180;
			textPlan.scaleX = bitmapData.width * 0.5 * Number(model.textScale);
			//textPlan.scaleY = 64 * 0.3 * Number(model.textScale);
			textPlan.scaleY = bitmapData.height * 0.5 * Number(model.textScale);
		}
		
		public function addLogo(logoUrl:String = null, $stage3D:Gim3DRootContainer = null,$isIcon:Boolean = false):void
		{
			if (logoUrl && logoUrl != "")
			{
				this._container3D = $stage3D;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
				loader.load(new URLRequest(logoUrl));
				isIcon = $isIcon;
			}
		}
		private var _container3D:Gim3DRootContainer;
		private var isIcon:Boolean = false;
		
		private function onLoad(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, onLoad);
			
			var bitmap:Bitmap = e.currentTarget.content as Bitmap;
			var bitmapTextureResource:BitmapTextureResource = new BitmapTextureResource(bitmap.bitmapData, true);
			var iconMaterial:TextureMaterial = new TextureMaterial(bitmapTextureResource);
			iconMaterial.alphaThreshold = 1;
			if (isIcon)
			{
				var placeTypeLogo:Sprite3D = new Sprite3D(bitmap.bitmapData.width, bitmap.bitmapData.height, iconMaterial);
				addChild(placeTypeLogo);
				placeTypeLogo.z = polygon3D._height + bitmap.bitmapData.height * 0.5;	//这里以免图标陷入地形中
				placeTypeLogo.x = polygon3D.centerPoint.x + Number(model.iconX);
				placeTypeLogo.y = -polygon3D.centerPoint.y - Number(model.iconY);
				placeTypeLogo.scaleX = placeTypeLogo.scaleZ = 0.5;						//对于某些项目来说,logo过大,需要缩小
				this.removeChild(polygon3D);
				_container3D.shadow.addCaster(placeTypeLogo);
			}
			else
			{
				//var icon:Plane = new Plane(bitmap.bitmapData.width, bitmap.bitmapData.width, 1, 1, false, false, null, iconMaterial);
				var icon:Plane = new Plane(1,1, 1, 1, false, false, null, iconMaterial);
				addChild(icon);
				icon.z = polygon3D._height + 1;
				icon.scaleX = bitmap.bitmapData.width * 0.95 * Number(model.iconScale);
				icon.scaleY = bitmap.bitmapData.height * 0.95 * Number(model.iconScale);
				icon.x = polygon3D.centerPoint.x + Number(model.iconX);
				icon.y = -polygon3D.centerPoint.y - Number(model.iconY);
				icon.rotationZ = - Number(model.iconRotate) * Math.PI/180;
			}
			
			for each (var resource:Resource in this.getResources(true))
			{
				resource.upload(_container3D.stage3D.context3D);
			}
			//trace("- Place uploadResources", model.iconRotate);
		}
		
		private function onMouseClick(e:MouseEvent3D):void
		{
			this.dispatchEvent(new Event3D("PLACE_CLICK", true));
		}
	}

}