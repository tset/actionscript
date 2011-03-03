
package com.odbo
{

	  import odbo.EventCentral;
	  import odbo.ProjectEvent;
	  import com.greensock.dataTransfer.XMLManager;
	  import flash.events.*;
	  
      class XMLParseObject
	  {
		private var xmlMan:XMLManager;
		private var _object:Object;
		
		function XMLParseObject(xml:String) 
		{
				_object = new Object();
				text_holder = new Object();
				xmlMan = new XMLManager();
				addListeners();
				loadXML(xml)
		};
	
		public function loadXML(xmlDoc:String):void
		{
				xmlMan.load(xmlDoc);
		};
	
		function onComplete(event:Event):void 
		{
			
			var parsedObject:Object = event.target.parsedObject;
		//	Trace.obj(parsedObject);
			
			for (var a:uint = 0; a < parsedObject.video.length; a++) 
			{
						for (var b:uint = 0; b < parsedObject.video[a].player.length; b++) 
						{
								_object.flv = parsedObject.video[a].player[b].flv;
								_object.FSflv = parsedObject.video[a].player[b].FSflv;
								_object.screenshot = parsedObject.video[a].player[b].bg;
								_object.W = parsedObject.video[a].player[b].W;
								_object.H = parsedObject.video[a].player[b].H;
								_object.autoplay = false;
								_object.fullScreen = true;
								_object.X = parsedObject.video[a].player[b].X;
								_object.Y = parsedObject.video[a].player[b].Y;
								_object.skin = parsedObject.video[a].player[b].skin;
								_object.bg = parsedObject.video[a].player[b].bg;
								
							for(var c:uint = 0; c < parsedObject.video[a].player[b].text.length; c++)
							{
									text_holder[c] = {
															text:parsedObject.video[a].player[b].text[c].nodeValue, 
															link:parsedObject.video[a].player[b].text[c].link,
															cue:parsedObject.video[a].player[b].text[c].cue,
															xPos:parsedObject.video[a].player[b].text[c].x,
															yPos:parsedObject.video[a].player[b].text[c].cue,
															delay:parsedObject.video[a].player[b].text[c].delay
															};
							};
								_object.holder = text_holder;
						};
				};
				sendObject();
			};
		
		private function sendObject():void
		{
			EventCentral.getInstance().dispatchEvent(new ProjectEvent('ProjectEvent.XML_LOADED',{object:_object}));
		};
		
		private function addListeners():void
		{
			xmlMan.addEventListener(Event.COMPLETE, onComplete);

		};
	};
};

