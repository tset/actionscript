package com.blitzagency.xray.inspector
{
	import com.blitzagency.xray.inspector.commander.Commander;
	import com.blitzagency.xray.inspector.util.ControlConnection;
	import com.blitzagency.xray.inspector.util.ObjectInspector;
	import com.blitzagency.xray.logger.XrayLog;
	import com.blitzagency.xray.logger.util.ObjectTools;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	* This is the main entry point for Xray
	* <p/>
	* Xray needs to be added to a sprite to gain access to the stage property.  The Flex2Xray class extends Xray and overrides the init method.  The Flex2Xray instance does not have to
	* added to any display list, just use the new constructor and it'll light right up
	*/
	
	public class Xray extends Sprite
	{
		public var useMouseHighlighting							:Boolean = false;
		
		protected var log										:XrayLog = new XrayLog();
		protected var objectInspector							:ObjectInspector;
		protected var controlConnection							:ControlConnection;
		
		public function Xray(useMouseHighlighting:Boolean=false)
		{
			this.useMouseHighlighting = useMouseHighlighting;
			init();
		}
		
		protected function init():void
		{
			var isLivePreview:Boolean = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
			// if parent is null, then we're in livePreview
			if(isLivePreview) return;
			
			visible = false;
			
			objectInspector = new ObjectInspector();
			
			// we need to listen for when Xray's added to a DisplayList - then we can set Stage
			addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			
			controlConnection = new ControlConnection();
			controlConnection.setObjectInspector(objectInspector);
			controlConnection.initConnection();
			
			controlConnection.send("_xray_conn", "checkFPSOn");
		}
		
		protected function handleAddedToStage(e:Event):void
		{
			// doing this so that ObjectInspector will have it's own stage property to work with
			objectInspector.stage = stage; 
			
			Commander.getInstance().objectInspector = objectInspector;
			Commander.getInstance().stage = stage.getChildByName("root1") as DisplayObjectContainer;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
		}
		
		protected function handleMouseMove(e:MouseEvent):void
		{
			var ary:Array = stage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
			//strace("Objects under mouse", ary.length);
			for( var i:int=0; i<ary.length; i++)
			{
				 if( ary[i] as Sprite != null && Sprite(ary[i]).hasOwnProperty("focusRect") )
				{
					Sprite(ary[i]).focusRect = true;
					stage.focus = ary[i];
				} 
				/* if( ary[i] as Sprite != null && Sprite(ary[i]).hasOwnProperty("graphics") )
				{
					drawHighlight(Sprite(ary[i]));
				} */
				
				trace("object: ", ary[i].name, ObjectTools.getImmediateClassPath(ary[i]));
			}
		}
	}
}