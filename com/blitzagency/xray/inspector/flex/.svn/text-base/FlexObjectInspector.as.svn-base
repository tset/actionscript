package com.blitzagency.xray.inspector.flex
{
	import com.blitzagency.xray.inspector.util.ObjectInspector;
	import com.blitzagency.xray.logger.util.ObjectTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.Application;
	import mx.core.IChildList;

	public class FlexObjectInspector extends ObjectInspector
	{
		
		public function FlexObjectInspector()
		{
			super();
		}
		
		public override function buildObjectFromString(target:String):Object
		{
			var obj:Object = mx.core.Application.application as Application;
			
			var ary:Array = target.split(".");

			if(ary.length == 1) 
			{
				currentTargetPath = "application";
				return obj
			}
			
			return parseObjectString(ary, obj);
		}	
		
		public override function parseObjectsForReturn(obj:Object, returnObj:Object):Object
		{
			returnObj = super.parseObjectsForReturn(obj, returnObj);
			
			if( obj is IChildList )
			{
				//log.debug("IS RawChild");
				returnObj = processRawChildren(obj, returnObj);
			}
			
			return returnObj;
		}
		
		public function processRawChildren( obj:Object, returnObj:Object ):Object
		{
			var className:String = "";
			var value:Object;
			
			for(var i:Number=0;i<obj.numChildren;i++)
			{
				className = ObjectTools.getImmediateClassPath(obj.getChildAt(i));
				className = className == null ? String(i) : className;
				value = obj.getChildAt(i);
				returnObj[i] = className + "::" + value;
			}
				
			return returnObj;
		}
		
		override public function inspectObject(target:String):String
		{
			// reset the list
			returnList = "";
			try
			{
				currentTargetPath = target;
				
				//trace("************ inspectObject", target);
				// get object reference
				var obj:DisplayObjectContainer = DisplayObjectContainer(buildObjectFromString(target));
				//trace("************** inspect object", obj, obj.numChildren, obj is DisplayObject);
				if( (obj.hasOwnProperty("numChildren") && obj.numChildren == 0 && obj["rawChildren"].numChildren == 0) || obj is DisplayObject == false) return "";
				
				// the currentTarget should be correct now.  Create root node
				var className:String = getQualifiedClassName(obj).split("::")[1] == undefined ? getQualifiedClassName(obj) : getQualifiedClassName(obj).split("::")[1]
				returnList = "<" + currentTargetPath + " label=\"" + currentTargetPath + " (" + className + ")\" mc=\"" + currentTargetPath + "\" t=\"2\" >";
				
				// check for displayObject
				if( obj is DisplayObject ) 
				{
					if( obj.numChildren > 0 && !obj.hasOwnProperty("rawChildren") )
						buildDisplayList(obj); 
					else if( obj["rawChildren"].numChildren > 0 )
					{
						//currentTargetPath += ".rawChildren";
						buildDisplayList(obj["rawChildren"]);
					}
						
					buildObjectList(obj);
				}
				
				returnList += "</" + currentTargetPath + ">";				
			}catch(e:Error)
			{
				log.error("inspect object error: " + currentTargetPath, e.message);
			}
			
			return returnList;		
		}
		
		override protected function checkOtherChildSources(obj:Object, index:Number):Object
		{
			if( obj.rawChildren.numChildren > index ) return obj.rawChildren.getChildAt(index);
			return null
		}
		
		override protected function buildDisplayList(obj:Object):void
		{
			//trace("is rawChild", obj is IChildList);
			try
			{
				for(var i:Number=0;i<obj.numChildren;i++)
				{
					var container:DisplayObject = obj.getChildAt(i);
					var name:String = container.name;
					var className:String = getQualifiedClassName(container).split("::")[1];
					var key:String = obj is IChildList ? String(i) : name;
					var mc:String = currentTargetPath + "." + key;
					//trace("mc path", mc);
					// add to the return string
					addToReturnList(name, className, mc);
				}
			}catch(e:Error)
			{
				log.debug("buildDisplayList error", e.message);
			}
		}
	}
}