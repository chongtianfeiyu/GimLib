package gim.maps
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Box;
	
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import gim.gimA3D.Gim3DRootContainer;
	import gim.maps.models.Model;
	import gim.maps.models.ModelFloor;
	import gim.maps.models.ModelNode;
	import gim.maps.models.ModelPath;
	import gim.maps.models.ModelPlace;
	import gim.maps.models.ModelPlaceType;
	import gim.maps.models.ModelShop;
	import gim.maps.structs.Floor;
	import gim.maps.structs.GimPlayer3D;
	import gim.maps.structs.Place;
	import gim.maps.structs.Struct3D;
	import gim.tools.GimTools;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimMap3D extends Map
	{
		public var maxRotationX:Number = 0;
		public var minRotationX:Number = -Math.PI / 3;
		public var isMoveMode:Boolean = true;
		public var placeBaseHeight:Number = 20;
		public var defaultRotationX:Number = 0;
		public var defaultRotationZ:Number = 0;
		public var defaultCameraDistance:Number = 0;
		public var maxCameraDistance:Number;
		public var minCameraDistance:Number;
		public var placeFocusColor:uint = 0;
		
		public var rootContainer3D:Gim3DRootContainer;
		private var currentSelectedPlace:Place;
		private var player:GimPlayer3D;
		
		public function GimMap3D()
		{
			super();
		}

		/**
		 * 初始化
		 * */
		override public function init(onMapCreateComplete:Function):void
		{
			super.init(onMapCreateComplete);
			
			//add rootContainer3D
			this.rootContainer3D = new Gim3DRootContainer(_mapWidth,_mapHeight,initData);	//必须完成后才能进行下一步
			rootContainer3D.defaultRotationX = defaultRotationX;
			rootContainer3D.defaultRotationZ = defaultRotationZ;
			rootContainer3D.defaultCameraDistance = defaultCameraDistance;
			rootContainer3D.maxCameraDistance = maxCameraDistance;
			rootContainer3D.minCameraDistance = minCameraDistance;
			rootContainer3D.placeFocusColor = placeFocusColor;
			this.addChild(rootContainer3D);
		}
		
		private function initData():void
		{
			var xmlNode:XML;
			
			//floors
			var floor:Floor;
			for each (xmlNode in _xmlFloorList.children())
			{
				floor = new Floor(new ModelFloor(xmlNode));
				floors[floor.model.id] = floor;
			}
			
			//placeTypes
			for each (xmlNode in _xmlPlaceType.children())
			{
				var placeType:ModelPlaceType = new ModelPlaceType(xmlNode);
				placeTypes[placeType.id] = placeType;
			}
			
			//shops
			for each (xmlNode in _xmlShopList.children())
			{
				var shop:ModelShop = new ModelShop(xmlNode);
				shops[shop.placeID] = shop;
			}
			
			var placeTypeLogoUrl:String;
			//places,nodes
			for each (xmlNode in _xmlPlaceList.children())
			{
				var placeModel:ModelPlace = new ModelPlace(xmlNode);
				var placeTypeTmp:ModelPlaceType = placeTypes[placeModel.placeTypeID];
				if (!placeTypeTmp)
					continue;
				
				var setPlaceNotShop:Function = function(placeTmp:Place,placeHeight:Number,logoURL:String):void
				{
					placeTmp = new Place(placeModel, placeBaseHeight * placeHeight);
					place.addLogo(logoURL, rootContainer3D, true);
				}
					
				var place:Place;
				switch (placeTypeTmp.data)
				{
					case "shop": 
						place = new Place(placeModel, placeBaseHeight);
						var shopModel:ModelShop = shops[place.model.id];
						if (shopModel) place.addLogo(server + shopModel.logoURL, rootContainer3D);
						break;
					case "device position": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "other": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "toilet": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "escalator": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "lift": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "ground": 
						place = getNotShopLogoPlace(placeModel);
						break;
					case "patio": //天井
						floors[placeModel.floorID].addPatio(placeModel);
						break;
					default: 
						place = new Place(placeModel, placeBaseHeight * 0.2);
						break;
				}
				
				if (place)
				{
					places[place.model.nodeID] = place;
					floors[placeModel.floorID].addPlace(place);
					
					var placeNode:ModelNode = new ModelNode(xmlNode);
					nodes[placeNode.nodeID] = placeNode;
					
					floor = floors[placeNode.floorID];
					if (floor)
						floor.nodes[placeNode.nodeID] = nodes[placeNode.nodeID]; //应该是传的引用,会同步改变吗?
					
					placeNode.x = place.position.x;
					placeNode.y = place.position.y;
					
					if (place.model.nodeID == currentDiviceNodeID)
					{
						currentDivicePlace = place;
					}
				}
			}
			
			//nodes
			for each (xmlNode in _xmlPointList.children())
			{
				var node:ModelNode = new ModelNode(xmlNode);
				nodes[node.nodeID] = node;
				
				floor = floors[node.floorID];
				if (floor)
					floor.nodes[node.nodeID] = nodes[node.nodeID]; //应该是传的引用,会同步改变吗?
			}
			
			//pathes,nodes
			for each (xmlNode in _xmlPathList.children())
			{
				var path:ModelPath = new ModelPath(xmlNode);
				pathes[path.id] = path;
				
				var node1:ModelNode = nodes[path.node1ID];
				var node2:ModelNode = nodes[path.node2ID];
				if (node1 && node2)
				{
					node1.addRelatedNodes(node2);
					node2.addRelatedNodes(node1);
				}
			}
			
			//floors init
			for each (floor in floors)
			{
				floor.init();
				rootContainer3D.addChild3D(floor);
				floor.visible = false;
			}
			
			mapPosition = floor.polygon3D.centerPoint;
			rootContainer3D.offsetPoint = floor.polygon3D.centerPoint;
			
			if (currentDivicePlace)
				floorID = currentDivicePlace.model.floorID; //这里当改成设置当前位置后当前位置所在floor显示
			
			//add background
			rootContainer3D.addBackground(backgroundUrl);
			
			//add player
			rootContainer3D.addChild3D(player = new GimPlayer3D(8));
			
			addEventListeners();
			
			_onMapCreateCompleteFunc();
		}
		
		/**
		 * 得到以placeType的logo展现的非shop的place对象
		 * */
		private function getNotShopLogoPlace(placeModel:ModelPlace,placeHeight:Number = 0):Place
		{
			var place:Place = new Place(placeModel, placeBaseHeight * placeHeight);
			place.addLogo(server + placeTypes[placeModel.placeTypeID].logoURL, rootContainer3D, true);
			return place;
		}
		
		public function setMoveMode():void
		{
			this.isMoveMode = true;
		}
		
		public function setRotateMode():void
		{
			this.isMoveMode = false;
		}
		
		private function addEventListeners():void
		{
			rootContainer3D.rootContainer.addEventListener("PLACE_CLICK", onPlaceClick3D);
			rootContainer3D.camera.view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			rootContainer3D.camera.view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			rootContainer3D.camera.view.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (!rootContainer3D.rootContainer.hasEventListener("PLACE_CLICK"))
			{
				//延迟监听点击事件,修正鼠标抬起立刻响应点击事件的问题
				setTimeout(function():void
					{
						rootContainer3D.rootContainer.addEventListener("PLACE_CLICK", onPlaceClick3D)
					}, 0.1);
			}
		}
		
		private var origMouseX:Number;
		private var origMouseY:Number;
		
		private function onMouseDown(e:MouseEvent):void
		{
			origMouseX = rootContainer3D.camera.view.mouseX;
			origMouseY = rootContainer3D.camera.view.mouseY;
			rootContainer3D.camera.view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (rootContainer3D.rootContainer.hasEventListener("PLACE_CLICK"))
				rootContainer3D.rootContainer.removeEventListener("PLACE_CLICK", onPlaceClick3D);
			var deltaMouseX:Number = rootContainer3D.camera.view.mouseX - origMouseX;
			var deltaMouseY:Number = rootContainer3D.camera.view.mouseY - origMouseY;
			
			origMouseX = rootContainer3D.camera.view.mouseX;
			origMouseY = rootContainer3D.camera.view.mouseY;
			
			if (isMoveMode)
			{
				var cameraAngle:Number = -rootContainer3D.cameraRotateZContainer.rotationZ;
				
				var aX:Number = deltaMouseX * Math.cos(cameraAngle) - deltaMouseY * Math.sin(cameraAngle);
				var aY:Number = deltaMouseY * Math.cos(cameraAngle) + deltaMouseX * Math.sin(cameraAngle);
				
				Tweener.removeTweens(rootContainer3D.cameraMoveContainer);
				Tweener.addTween(rootContainer3D.cameraMoveContainer, {x: rootContainer3D.cameraMoveContainer.x - aX * 2, y: rootContainer3D.cameraMoveContainer.y + aY * 2, time: 1});
				
				AppConfig.instance.log("GimMap3D,284,positionX:" + rootContainer3D.cameraMoveContainer.x + " positionY:" + rootContainer3D.cameraMoveContainer.y);
				//trace("- GimMap3D,284,positionX:",rootContainer3D.cameraMoveContainer.x,"positionY:",rootContainer3D.cameraMoveContainer.y);
			}
			else
			{
				var aimX:Number = rootContainer3D.cameraRotateXContainer.rotationX - deltaMouseY * 0.01;
				var aimZ:Number = rootContainer3D.cameraRotateZContainer.rotationZ - deltaMouseX * 0.01;
				if (aimX > maxRotationX)
				{
					aimX = maxRotationX;
				}
				else if (aimX < minRotationX)
				{
					aimX = minRotationX;
				}
				Tweener.removeTweens(rootContainer3D.cameraRotateXContainer);
				Tweener.addTween(rootContainer3D.cameraRotateXContainer, {rotationX: aimX, time: 1});
				Tweener.removeTweens(rootContainer3D.cameraRotateZContainer);
				Tweener.addTween(rootContainer3D.cameraRotateZContainer, {rotationZ: aimZ, time: 1});
				
				AppConfig.instance.log("GimMap3D,300,rotationX:" + aimX * 180 / Math.PI + " rotationZ:" + aimZ * 180 / Math.PI);
				//trace("- GimMap3D,300,rotationX:",aimX * 180 / Math.PI,"rotationZ:",aimZ * 180 / Math.PI);
			}
		}
		
		/**
		 * 设置nodeID以选中place
		 * */
		override public function set currentSelectedNodeID(value:String):void
		{
			super.currentSelectedNodeID = value;
			
			clearCurrentSelectedPlace();
			var place:Place = places[value];
			if (place)
			{
				floorID = place.model.floorID;
				currentSelectedPlace = place;
				tmpMaterial = place.polygon3D.getSurface(0).material;
				
				currentSelectedPlace.polygon3D.setMaterialToAllSurfaces(rootContainer3D.placeFocusMaterial);
				Tweener.removeTweens(place);
				Tweener.addTween(place, {scaleZ: 1.8, time: 0.6, transition: "easeOutElastic"});
				
				mapPosition = currentSelectedPlace.position;
			}
		}
		private var tmpMaterial:Material;
		
		private function onPlaceClick3D(e:Event3D):void
		{
			var place:Place = e.target as Place;
			if (place)
			{
				AppConfig.instance.log("GimMap3D 158, current selected nodeID:" + place.model.nodeID);
//				trace("- GimMap3D 158, current selected nodeID:", place.model.nodeID);
				currentSelectedNodeID = place.model.nodeID;
			}
			
			onPlaceClick(place.model.id);
		}
		
		private function clearCurrentSelectedPlace():void
		{
			if (currentSelectedPlace)
			{
				//currentSelectedNodeID = "";
				currentSelectedPlace.polygon3D.setMaterialToAllSurfaces(tmpMaterial);
				Tweener.removeTweens(currentSelectedPlace);
				Tweener.addTween(currentSelectedPlace, {scaleZ: 1, time: 1, transition: "easeIn"});
			}
		}
		
		override public function reset():void
		{
			super.reset();
			
			rootContainer3D.reset();
			clearCurrentSelectedPlace();
			floorID = currentDivicePlace.model.floorID;
			//mapPosition = currentDivicePlace.position;
			hidePath();
		}
		
		/**
		 * 将传入的point作为中心位置
		 * */
		override public function set mapPosition(point:Point):void
		{
			super.mapPosition = point;
			
			var cameraContainer:Object3D = rootContainer3D.cameraMoveContainer;
			Tweener.removeTweens(cameraContainer);
			Tweener.addTween(cameraContainer, {x: mapPosition.x, y: -mapPosition.y, time: 0.6});
		}
		
		override public function findPath(startNodeID:String, endNodeID:String, $nodes:Object = null):void
		{
			if (!startNodeID || !endNodeID)
				return;
			
			super.findPath(startNodeID, endNodeID);
			trace("- GimMap3D 319,findPath", startNodeID, endNodeID);
			if (foundPathNodes != null && foundPathNodes.length > 0)
			{
				trace("- GimMap3D 322, path found!", foundPathNodes.length, foundPathNodes, $nodes);
				showPath(foundPathNodes);
			}
			else
			{
				trace("- GimMap3D 322, NO path found!");
				hidePath();
			}
		}
		
		override public function showPath(foundPathNodes:Array):void
		{
			super.showPath(foundPathNodes);
			hideAllFloors();
			var floorHeight:Number = 1200;
			var visibleFloors:Array = [];
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			for each (var node:ModelNode in foundPathNodes)
			{
				var floor:Floor = floors[node.floorID];
				if (visibleFloors.indexOf(floor) == -1)
				{
					visibleFloors.push(floor);
					floor.visible = true;
					floor.z = visibleFloors.indexOf(floor) * floorHeight;
				}
				points.push(new Vector3D(node.x, -node.y, floor.z + 3));
			}
			
			var length:Number = visibleFloors.length;
			var allHeight:Number = (length - 1) * floorHeight;
			var deltaHeight:Number = -allHeight / 2;
			for each (floor in visibleFloors)
			{
				floor.z += deltaHeight;
			}
			
			for each (var vector3D:Vector3D in points)
			{
				vector3D.z += deltaHeight;
			}
			
			rootContainer3D.pathFrame = WireFrame.createLineStrip(points, 0xff0033, 1, 3);
			rootContainer3D.rootContainer.addChild(rootContainer3D.pathFrame);
			rootContainer3D.uploadResources(rootContainer3D.pathFrame);
			
			if (player)
			{
				player.move(points, 10);
					//player.addChild(rootContainer3D.cameraMoveContainer);	//也可以实现漫游模式
			}
		}
		
		override public function hidePath():void
		{
			super.hidePath();
			
			if (rootContainer3D.pathFrame.parent == rootContainer3D.rootContainer)
				rootContainer3D.rootContainer.removeChild(rootContainer3D.pathFrame);
			
			if (player)
			{
				player.stop();
			}
		}
	}

}