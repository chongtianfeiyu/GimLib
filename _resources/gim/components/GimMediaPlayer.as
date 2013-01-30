package gim.components
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**
	 * 根据从
	 * @author Gamba
	 */
	public class GimMediaPlayer extends Sprite
	{
		public var bitmapLastTime:int = 6000;
		public var switchOutTime:Number = 100;
		
		private var WIDTH:Number;
		private var HEIGHT:Number;
		
		public var currentPlayIndex:int = 0;
		private var currentPlayUrl:String;
		
		private var videoContainer:Video;
		private var bitmapContainer:Sprite;
		private var loading:GimLoading;
		
		private var netStream:NetStream;
		private var bmpScaleX:Number;
		private var bmpScaleY:Number;
		
		private var _playList:Array = [];
		
		public function get playList():Array
		{
			return _playList;
		}
		
		public function set playList(value:Array):void
		{
			_playList = value;
			if (playList.length > 0) //如果本地列表为1,表示空列表中刚刚放入了一个路径,开始播放
			{
				playByIndex(0);
			}
		}
		
		public function GimMediaPlayer(width:Number, height:Number)
		{
			this.WIDTH = width;
			this.HEIGHT = height;
			
			//draw background
			this.graphics.beginFill(0, 0.95);
			this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			this.graphics.endFill();
			
			initVideo();
			initBitmap();
			initLoading();
			
			clearDisplayList();
			addChild(loading);
		}
		
		private var intervalId:uint = 0;
		public function stopPlay():void
		{
			netStream.close();
			videoContainer.clear();
			clearTimeout(intervalId);
		}
		
		public function playByIndex(index:int = 0):void
		{
			if (playList.length <= 0)
				return; //如果播放列表为空,返回
			
			currentPlayIndex = index;
			currentPlayUrl = playList[currentPlayIndex];
			trace("- GimMediaPlayer play:",currentPlayUrl,"index of list:",currentPlayIndex);
			
			if (currentPlayUrl.substr(currentPlayUrl.length - 3, 3) == "flv")
				playVideo();
			else
				playBitmap();
		}
		
		private function playVideo():void
		{
			clearDisplayList();
			addChild(videoContainer);
			netStream.play(currentPlayUrl);
		}
		
		private function onError(e:IOErrorEvent):void
		{
			trace(e);
		}
		
		private function doNetStatus(e:NetStatusEvent):void
		{
			//trace(e.info.code);
			switch (e.info.code)
			{
				case "NetStream.Play.Stop": 
					doPlayOver();
					break;
			}
		}
		
		private function playBitmap():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Error):void{});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBitmapComplete);
			loader.load(new URLRequest(currentPlayUrl));
		}
		
		private function loadBitmapComplete(e:Event):void
		{
			var bitmap:Bitmap = e.currentTarget.content as Bitmap;
			bitmapContainer.addChild(bitmap);
			bitmap.x = - bitmap.width * .5;
			bitmap.y = - bitmap.height * .5;
			bmpScaleX = WIDTH / bitmap.width;
			bmpScaleY = HEIGHT / bitmap.height;
			var scale:Number = bmpScaleX < bmpScaleY ? bmpScaleX : bmpScaleY;
			bitmapContainer.scaleX = bitmapContainer.scaleY = scale;
			
			clearDisplayList();
			addChild(bitmapContainer);
			
			Tweener.removeTweens(bitmapContainer);
			bitmapContainer.alpha = 0;
			Tweener.addTween(bitmapContainer, {alpha: 1, time: 1});
			
			intervalId = setTimeout(doPlayOver, bitmapLastTime);
		}
		
		public function doPlayOver():void
		{
			if (videoContainer)
				videoContainer.clear();
			while(bitmapContainer.numChildren > 0)
			{
				var bitmap:Bitmap = bitmapContainer.removeChildAt(0) as Bitmap;
				bitmap.bitmapData.dispose();
			}
			netStream.close();
			
			clearDisplayList();
			addChild(loading);
			
			//playNext();
			intervalId = setTimeout(playNext, switchOutTime);
		}
		
		private function playNext():void
		{
			currentPlayIndex++;
			if (currentPlayIndex > playList.length - 1) //列表播放完成
			{
				currentPlayIndex = 0;
				System.gc(); //清理缓存
			}
			playByIndex(currentPlayIndex);
		}
		
		private function clearDisplayList():void //清除显示列表
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
				//this.getChildAt(0);
				//Tweener.removeTweens(this.getChildAt(0), { x: -WIDTH,onComplete:function():void{} } );
			}
		}
		
		
		private function initVideo():void
		{
			var netConnection:NetConnection;
			netConnection = new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.client = new Object();
//			videoContainer = new Video(1080,810);
//			videoContainer.y = 555;
			videoContainer = new Video(WIDTH, HEIGHT);
			videoContainer.attachNetStream(netStream);
			netStream.addEventListener(IOErrorEvent.IO_ERROR, onError);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
		}
		
		private function initBitmap():void
		{
			bitmapContainer = new Sprite();
			bitmapContainer.x = WIDTH * .5;
			bitmapContainer.y = HEIGHT * .5;
		}
		
		private function initLoading():void
		{
			loading = new GimLoading(24, 3, 12, 0xffffff);
			loading.x = WIDTH * .5;
			loading.y = HEIGHT * .5;
		}
	}

}