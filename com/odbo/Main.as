
package com.odbo
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;

	import com.odbo.StageReference;
	import com.odbo.EventCentral;
	import com.odbo.ProjectEvent;
	
	import com.odbo.Player;
	import com.odbo.odVbo;
	import com.odbo.Cues;
	import com.odbo.XMLParseObject;
	  
	public class Main extends MovieClip
	{
		var thisStage;
		private var _player:odVbo;
		private var _object:Object;
		private var text_holder:Object;
		
		private var xmlDoc:String;
		private var xmlParseObject:XMLParseObject;
		
		function Main(xml:String, scope:*)
		{
			thisStage = scope;
			_object = new Object();
			addListeners();
			
			xmlDoc = xml;
			loadXML(xmlDoc);
		};
	
		private function loadXML(xml:String):void
		{
			xmlParseObject = new XMLParseObject(xml);
		};
	
		private function dataSet(event:ProjectEvent):void
		{
			_object = event.params.object;
			addCues();
			addPlayer();
		};
	
		private function addPlayer():void
		{			
			_player = new odVbo(_object);
			thisStage.addChild(_player);
		};
	
		private function addCues():void
		{
			_cues = new Cues(_object, thisStage);
			thisStage.addChild(_cues);
		}
	
		private function addListeners():void
		{
			EventCentral.getInstance().addEventListener('ProjectEvent.XML_LOADED', dataSet);
		};
	
	};
};





