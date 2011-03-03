package com.odbo 
{
	import com.odbo.Frame;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import org.casalib.util.StageReference;
	
	public class aStage 
	{
		private var thisStage:Stage;
		private var thisRoot:MovieClip;
		private var newFrame:Frame;
		private var sWidth:Number;
		private var sHeight:Number;
		private var fWidth:Number;
		private var rot:Number;
		private var corner:Number;
		public var contentsHolder:MovieClip;
		public var contents:MovieClip
		private var beHeight:Number;
		private var beWidth:Number;
		private var stageHolder:Object;
		
		function aStage()
		{
			stageHolder = new Object();
		};
		 
		
		public function setStage():Object
		{
	//	trace("stage width " + sWidth + " stage height " + sHeight)
			thisStage = StageReference.getStage();	
			sWidth = 975;
			sHeight = 600;
			fWidth = 1;
			rot = Math.PI / 4;
			corner = 5;
			beHeight = 50;
			beWidth = 2;
			newFrame = new Frame();
			contentsHolder = newFrame.addFrame(thisStage, // scope
				0, 0, sWidth, sHeight, // xPos, yPos, width, height
				fWidth, 0x000000, 0xFFFFFF, // frame width, start colour, end colour
				0xFFFFFF, rot, corner ); // gradient, rotation, corner
			
			contents = newFrame.addFrame(contentsHolder, // scope
				beWidth/2, beHeight + (beWidth/2), sWidth - beWidth, sHeight - beWidth - beHeight, // xPos, yPos, width, height
				beWidth, 0x000000, 0xCC9900, // frame width, start colour, end colour
				0xCC9900, rot, corner ); // gradient, rotation, corner
			
			stageHolder["top"] = contentsHolder;
			stageHolder["middle"] = contents;
			stageHolder["main"] = thisStage;
			
			return stageHolder;
		};
	};
};