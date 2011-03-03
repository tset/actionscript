package com.odbo
{

import flash.events.*;

    public class EventCentral extends EventDispatcher 
	{
    private static var instance:EventCentral;
    public static function getInstance():EventCentral {
      if (instance == null){
         instance = new EventCentral(new SingletonBlocker());
      }
      return instance;
}
      public function EventCentral(blocker:SingletonBlocker):void{
        super();
        if (blocker == null) {
           throw new Error("Error: instantiation failed; Use EventCentral.getInstance()");
       }
}
        public override function dispatchEvent($event:Event):Boolean{
        return super.dispatchEvent($event);
}
}
}
internal class SingletonBlocker {}


