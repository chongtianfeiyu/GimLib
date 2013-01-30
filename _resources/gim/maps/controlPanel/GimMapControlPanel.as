package gim.maps.controlPanel
{
	import alternativa.engine3d.core.events.MouseEvent3D;
	import caurina.transitions.Tweener;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gim.maps.GimMap3D;
	import gim.maps.Map;
	import gim.maps.structs.Floor;
	import gim.tools.GimTools;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimMapControlPanel extends Sprite
	{
		private const scaleStep:Number = 20;
		
		public var map:GimMap3D;
		
		public function GimMapControlPanel($map:GimMap3D)
		{
			map = $map;
			
			//floorList
			var onVContainerClick:Function = function(e:MouseEvent):void
			{
				//trace(e.currentTarget.currentSelectedIndex);
				map.floorID = GimVerticalContainer(e.currentTarget).currentSelectedElement.label;
			}
			var verticalContainer:GimVerticalContainer = new GimVerticalContainer();
			addChild(verticalContainer);
			verticalContainer.addEventListener(MouseEvent.CLICK, onVContainerClick);
			verticalContainer.y = 0;
			for each(var floor:Floor in map.floors)
			{
				var btn:PushButton = new PushButton();
				verticalContainer.addElement(btn);
				btn.label = floor.model.id;
			}
			
			//rotateButton
			var onRotate:Function = function(e:MouseEvent):void
			{
				map.setRotateMode();
			}
			var rotateButton:PushButton = new PushButton(this,0,verticalContainer.height + 15,"Rotate",onRotate);
			
			//moveButton
			var onMove:Function = function(e:MouseEvent):void
			{
				map.setMoveMode();
			}
			var moveButton:PushButton = new PushButton(this, 0, rotateButton.y + rotateButton.height + 5, "Move", onMove);
			
			//scaleButtons
			var onScale:Function = function(e:MouseEvent):void
			{
				var currentClickBtn:PushButton = e.currentTarget as PushButton;
				if (currentClickBtn.label == "scale+")
				{
					trace("- GimMapControlPanel 66, scale+");
					map.rootContainer3D.cameraDistance -= scaleStep;
				}else if (currentClickBtn.label == "scale-")
				{
					trace("- GimMapControlPanel 66, scale-");
					map.rootContainer3D.cameraDistance += scaleStep;
				}
				
			}
			var scalePlusButton:PushButton = new PushButton(this, 0, moveButton.y + moveButton.height + 5, "scale+", onScale);
			var scaleMinusButton:PushButton = new PushButton(this, 0, scalePlusButton.y + scalePlusButton.height, "scale-", onScale);
			var onMouseWheel:Function = function(e:MouseEvent):void
			{
				map.rootContainer3D.cameraDistance -= e.delta * scaleStep;
			}
			map.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			//reset
			var onReset:Function = function(e:MouseEvent):void
			{
				map.reset();
			}
			var resetButton:PushButton = new PushButton(this, 0, scaleMinusButton.y + scaleMinusButton.height + 5, "Reset", onReset);
			
			//findPath
			var findPath:Function = function(e:MouseEvent):void
			{
				map.findPath(map.currentDiviceNodeID, map.currentSelectedNodeID);
			}
			var findPathButton:PushButton = new PushButton(this, 0, resetButton.y + resetButton.height + 8, "findPath", findPath);
			
			//hidePath
			var hidePath:Function = function(e:MouseEvent):void
			{
				map.hidePath();
			}
			var hidePathButton:PushButton = new PushButton(this, 0, findPathButton.y + findPathButton.height, "hidePath", hidePath);
			
			//nodeID
			var onNodeID:Function = function(e:MouseEvent):void
			{
				map.currentSelectedNodeID = inputNodeID.text;
			}
			var inputNodeID:InputText = new InputText(this, 0, hidePathButton.height + hidePathButton.y + 5, "");
			var setNodeID:PushButton = new PushButton(this, 0, inputNodeID.height + inputNodeID.y, "nodeID", onNodeID);
		}
	}

}