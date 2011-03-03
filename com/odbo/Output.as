
package com.odbo
{
	  import flash.display.MovieClip;
	  import flash.events.Event;
	  import odbo.EventCentral;
	  import odbo.ProjectEvent;
	  
      public class Output extends MovieClip
	  {

		function Output()
		{
			
		};
	
		public function addTrace(output:String)
		{
			this.txt.htmlText += "<br>";
			this.txt.htmlText += output;
		};
	
	};
};

