
/**
 * @author odbo
 */
  
package com.odbo
{

        import flash.display.MovieClip;
        
        import org.valck.display.CommonRectangle;

		public class Frame extends MovieClip {

		public static var thisSquare:MovieClip;
		public var thisClip:MovieClip;
		public var thisMask:MovieClip;
		public var thisStage;
		
		private var rot:uint;
		private var xPos:uint;
		private var yPos:uint;
		private var sWidth:uint;
		private var sHeight:uint;
		private var fWidth:uint;
		private var thisColour:uint
		private var thisFrameColour:uint;
		private var thatFrameColour:uint;
		private var corner:uint;
			
		function Frame()
		{
			
		};
			
		 public function addFrame(thisS:*, xP:Number, yP:Number, 
								  sW:Number, sH:Number, f:Number, 
								  thisC:Number, thisF:Number, thatF:Number, 
								  r:Number, c:Number):MovieClip
		{	
			sWidth = sW;
			sHeight = sH;
			xPos = xP;
			yPos = yP;
			thisStage = thisS;
			thisColour = thisC;
			thisFrameColour = thisF;
			thatFrameColour = thatF;
			fWidth = f;
			rot = r;
			corner = c;
			thisClip = new MovieClip();
			thisStage.addChild(thisClip);
			
			thisSquare = new MovieClip();
			thisStage.addChild(thisSquare);
			
			drawBox(thisClip, 0, thisFrameColour, thatFrameColour);
			drawBox(thisSquare, 0, thisColour, thisColour);
			
			thisMask = new MovieClip();
			thisStage.addChild(thisMask);
			drawBox(thisMask, fWidth, thisFrameColour, thatFrameColour);

			thisSquare.mask = thisMask;
			
			return thisSquare;
		};
              
          public function drawBox(thisBox:MovieClip, fWidth:Number, thisColour:uint, thatColour:uint):CommonRectangle
          {
			  var rect : CommonRectangle = new CommonRectangle();
			  rect.topLeftCorner = corner;
			  rect.topRightCorner = corner;
			  rect.bottomRightCorner = corner;
			  rect.bottomLeftCorner = corner;
			  rect.width = sWidth  - (2*fWidth);
			  rect.height = sHeight - (2*fWidth);
			  rect.x = xPos + fWidth;
			  rect.y = yPos + fWidth;
			  rect.colors = [thisColour, thatColour];
			  rect.gradientRotation = rot;
			  thisBox.addChild(rect);
			  return rect;
          };
      };
};


	
