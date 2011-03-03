package com.blitzagency.xray.inspector.flex
{
	import com.blitzagency.xray.inspector.Xray;
	import com.blitzagency.xray.inspector.commander.Commander;
	import com.blitzagency.xray.inspector.util.ControlConnection;
	import com.blitzagency.xray.logger.util.ObjectTools;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import mx.core.Application;

	public class FlexXray extends Xray
	{		
		public function FlexXray(useMouseHighlighting:Boolean=false)
		{
			super(useMouseHighlighting);
		}	
		
		protected override function init():void
		{
			log.debug("Flex xray constructor called");
			
			objectInspector = new FlexObjectInspector();
			
			controlConnection = new ControlConnection();
			controlConnection.setObjectInspector(objectInspector);
			controlConnection.initConnection();
			
			Commander.getInstance().objectInspector = objectInspector;
			Commander.getInstance().stage = mx.core.Application.application as DisplayObjectContainer;
			
			controlConnection.send("_xray_conn", "checkFPSOn");
			
			if( useMouseHighlighting ) setTimeout(setupMouseHighlighting, 2000);
		}
		
		protected function setupMouseHighlighting():void
		{
			Application(Application.application).stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
		}
		
		override protected function handleMouseMove(e:MouseEvent):void
		{
			var ary:Array = Sprite(Application.application).getObjectsUnderPoint(new Point(e.stageX, e.stageY));
			//strace("Objects under mouse", ary.length);
			for( var i:int=0; i<ary.length; i++)
			{
				  if( ary[i] as Sprite != null && Sprite(ary[i]).hasOwnProperty("focusRect") )
				{
					Sprite(ary[i]).focusRect = true;
					Application(Application.application).stage.focus = ary[i];
				}  
				/*  if( ary[i] as Sprite != null && Sprite(ary[i]).hasOwnProperty("graphics") )
				{
					drawHighlight(Sprite(ary[i]));
				}  */
				
				trace("object: ", ary[i].name, ObjectTools.getImmediateClassPath(ary[i]));
			}
		}
		
		protected function drawHighlight(obj:Sprite):void
		{
			//obj.graphics.clear();
			var rect:Rectangle = obj.getBounds(Application(Application.application).stage);
			var g:Graphics = Application(Application.application).graphics;
            g.lineStyle(1,0x00ff00,1,false);
            g.drawRect(rect.x,rect.y,rect.width, rect.height);
            g.endFill();
		}
	}
}