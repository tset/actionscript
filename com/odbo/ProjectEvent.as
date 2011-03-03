package com.odbo
{
	import flash.events.Event
		public class ProjectEvent extends Event 
		{
			public static const DATA_EVENT:String = "ProjectEvent.onDataEvent";
			public static const LOAD_EVENT:String = "ProjectEvent.onLoadEvent";
			public static const BTN_EVENT:String = "ProjectEvent.onBtnEvent"
			public var params:Object;
			public function ProjectEvent($type:String,$params:Object = null){
				//trace("project event " + $type)
				super($type,true,true);
				this.params = $params;
			}
			public override function clone():Event 
			{
				return new ProjectEvent(this.type,this.params);
			}
			override public function toString():String
			{
				return ("[Event ProjectEvent]");
			}
		}
}
//To set up a listener:
/*EventCentral.getInstance().addEventListener('ProjectEvent.SOME_EVENT',handleSomeEvent);
function handleSomeEvent(event:ProjectEvent):void{
	trace(event.params.param1);
}

to dispatch:
EventCentral.getInstance().dispatchEvent(new ProjectEvent('ProjectEvent.SOME_EVENT',{param1:'something'}));
*/
