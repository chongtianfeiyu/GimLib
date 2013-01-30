package gim.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import caurina.transitions.Tweener;

	public class GimBrowser extends Sprite
	{
		public function GimBrowser($width:Number,$height:Number,$navBarVisible:Boolean = true)
		{
			//background
			drawRect($width,$height,this,0x222222,0.8);
			
			//mainPage
			htmlPage = new HTMLLoader();
			addChild(htmlPage);
			htmlPage.width = $width - padding * 2;
			htmlPage.height = $height - ($navBarVisible ? navBarHeight : 0) - padding * 2;
			htmlPage.x = padding;
			htmlPage.y = ($navBarVisible ? navBarHeight : 0) + padding;
			htmlPage.addEventListener(Event.COMPLETE,onLoad);
			
			//navigate bar
			if($navBarVisible)
			{
				navBar = new Sprite();
				addChild(navBar);
				drawRect($width,navBarHeight,navBar,0xEEEEEE,1);
				
				var prePageBtn:Sprite = new Sprite();
				navBar.addChild(prePageBtn);
				drawCircle(prePageBtn,20,0xff0033,1);
				prePageBtn.x = 30;
				prePageBtn.y = 30;
				
				var nextPageBtn:Sprite = new Sprite();
				navBar.addChild(nextPageBtn);
				drawCircle(nextPageBtn,20,0xff0033,1);
				nextPageBtn.x = 80;
				nextPageBtn.y = 30;
				
				var navInput:TextField = new TextField();
				navBar.addChild(navInput);
				navInput.width = $width - 180;
				navInput.height = 40;
				navInput.x = 120;
				navInput.y = 20;
				navInput.background = true;
				navInput.backgroundColor = 0xffffff;
				navInput.text = "www.baidu.com";
				navInput.setTextFormat(new TextFormat(null,24,0xff0033,true));
				
			}
			
			//close button
			var closeBtn:Sprite = new Sprite();
			addChild(closeBtn);
			drawCircle(closeBtn,padding - 2,0xffffff,0.6);
			drawCircle(closeBtn,padding - 2 - padding * 0.2,0x222222,1);
			closeBtn.graphics.lineStyle(padding * 0.2,0xEEEEEE,1);
			closeBtn.graphics.moveTo(- padding * 0.3,- padding * 0.3);
			closeBtn.graphics.lineTo(padding * 0.3,padding * 0.3);
			closeBtn.graphics.moveTo(- padding * 0.3,padding * 0.3);
			closeBtn.graphics.lineTo(padding * 0.3,- padding * 0.3);
			closeBtn.graphics.endFill();
			closeBtn.x = $width - padding;
			closeBtn.y = padding;
			closeBtn.filters = [new DropShadowFilter(2,90,0,0.8)];
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			
			//initialize
			close();
		}
		public var padding:Number = 20;
		private var navBar:Sprite;
		private var navBarHeight:Number = 80;
		
		protected function onClose(event:MouseEvent):void
		{
			close();
		}
		
		public function close():void
		{
			this.navigateTo("about:blank");
			
			this.alpha = 1;
			Tweener.removeTweens(this);
			Tweener.addTween(this,{alpha:0,time:1,onComplete:function():void{this.visible = false;}});
		}
		
		protected function onLoad(event:Event):void
		{
			trace(event);
		}
		private	var htmlPage:HTMLLoader;
		
		public function navigateTo(url:String):void
		{
			htmlPage.load(new URLRequest(url));
			
			this.visible = true;
			this.alpha = 0;
			Tweener.removeTweens(this);
			Tweener.addTween(this,{alpha:1,time:1});
		}
		
		//assist functions////////////////////////		
		private function drawRect($width:Number, $height:Number, $sprite:Sprite, $color:uint = 0xFFFFFF,$alpha:Number = 0.3):void
		{
			$sprite.graphics.beginFill($color,$alpha);
			$sprite.graphics.drawRect(0,0,$width,$height);
			$sprite.graphics.endFill();
		}
		
		private function drawCircle($sprite:Sprite,$radius:Number,$color:uint = 0xFFFFFF,$alpha:Number = 0.3):void
		{
			$sprite.graphics.beginFill($color,$alpha);
			$sprite.graphics.drawCircle(0,0,$radius);
			$sprite.graphics.endFill();
		}
	}
}