package com.blitzagency.xray.inspector.util
{
	import com.blitzagency.xray.logger.XrayLog;
	import com.blitzagency.xray.logger.util.ObjectTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	// we extend DisplayObject so that we can have access to the base stage property
	public class ObjectInspector extends EventDispatcher
	{			
		protected var log																	:XrayLog = new XrayLog();
		protected var returnList															:String = "";
		protected var currentTargetPath													:String = "";
		protected var _stage																:DisplayObjectContainer;
		
		public function set stage(p_stage:DisplayObjectContainer):void
		{
			_stage = p_stage;
		}
		
		public function get stage():DisplayObjectContainer
		{
			return _stage;
		}
		
		private var strings:Array = new Array
		(
			{
				replace:"&lt;", from:"<"
			},
			{
				replace:"&gt;", from:">"
			},
			{
				replace:"&apos;", from:"'"
			},
			{
				replace:"&quot;", from:"\""
			},
			{
				replace:"&amp;", from:"&"
			}
		)
		
		public function ObjectInspector():void
		{
			//constructor;
		}
		
		public function buildObjectFromString(target:String):Object
		{
			var obj:Object;
			
			try
			{
				//obj = stage.root;
				obj = stage.getChildAt(0) as DisplayObjectContainer;
				//obj = stage.getChildByName("root1") as DisplayObjectContainer;
			}catch(e:Error)
			{
				log.debug("stage is not initialized");
			}
			
			var ary:Array = target.split(".");

			if(ary.length == 1) 
			{
				currentTargetPath = "stage";
				return obj
			}
			
			return parseObjectString(ary, obj);
		}
		
		protected function parseObjectString(ary:Array, obj:Object):Object
		{
			var temp:* = null;
			for(var i:Number=1;i<ary.length;i++)
			{
				temp = null;
				//trace(" isNaN and property", isNaN(ary[i]), obj.hasOwnProperty("getChildByName"), obj.hasOwnProperty("getChildAt"));
				if( obj.hasOwnProperty("getChildByName") && isNaN(ary[i]) ) 
				{
					//trace("found pure object with string ID");
					temp = obj.getChildByName(ary[i]);
				}
				else if( obj.hasOwnProperty("getChildAt") && !isNaN(ary[i]) )
				{
					//trace("found rawchild mostlikely:: getChildAt", ary[i], obj is IChildList, obj.numChildren);
					//temp = obj.getChildAt(ary[i]);
					temp = checkOtherChildSources(obj, ary[i]);
				}
				else if( obj is Array )
				{
					//trace("FOUND ARRAY", ary[i]);
					temp = obj[Number(ary[i])];
				}
				else if( obj is Dictionary )
				{
					//trace("Dictionary Found");
					if( !isNaN(ary[i]) )
					{
						//trace("is Number", ary[i]);
						var counter:Number = 0;
						for each( var dObj:* in obj )
						{
							if( counter == Number(ary[i]) ) temp = dObj;
							counter++;
						}
					}
				}
				
				if( temp == null && obj.hasOwnProperty([String(ary[i])]) ) temp = obj[ary[i]];
				//trace("TEMP obj null?", temp == null);
                if( temp == obj) continue;
                if( temp == null ) break;
				//trace("Building path", ary[i], temp is Dictionary)
                obj = temp;
            }

			return obj;
		}
		
		// this is really for FleXray to be able to find rawChildren
		protected function checkOtherChildSources(obj:Object, index:Number):Object
		{
			if( obj.numChildren > index ) return obj.getChildAt(index);
			return null
		}
		
		public function getProperties(target:String):Object
		{
			var obj:* = buildObjectFromString(target);
			var returnObj:Object = {};
			
			
			returnObj.ClassExtended = ObjectTools.getFullClassPath(obj);
			returnObj.Class = ObjectTools.getImmediateClassPath(obj);
			
			var xml:XML = describeType(obj);
			
			var className:String = "";
			var value:*;
			
			//log.debug("describeType", (xml.toXMLString()));
			
			for each(var item:XML in xml.accessor)
			{
				try
				{
					if(item.@access.indexOf("read") > -1)
					{
						className = item.@type.split("::")[1];
						className = className == null ? item.@type : className;
						value = obj[item.@name];
						returnObj[item.@name] = className + "::" + value;
					}
					
				}catch(e:Error)
				{
					log.error("getProperties accessor error (" + item.@name  + ")", e.message);
					continue;
				}
			}
			
			for each(item in xml.variable)
			{
				try
				{
					//if( item.@type == "Object" || item.@type == "Array" || item.@type == "org.papervision3d.scenes::Scene3D" )
					//{
						className = item.@type.split("::")[1];
						className = className == null ? item.@type : className;
						value = obj[item.@name];
						returnObj[item.@name] = className + "::" + value;
					//}
					
				}catch(e:Error)
				{
					log.error("getProperties variable error (" + item.@name  + ")", e.message);
					continue;
				}
			}
			
			return parseObjectsForReturn(obj, returnObj);
		}
		
		public function parseObjectsForReturn(obj:Object, returnObj:Object):Object
		{
			if( obj is Dictionary )
			{
				//log.debug("IS Dictionary");
				//for(var items:String in obj)
				returnObj = processDictionary(obj, returnObj);
			}			
			else if( obj is Object )
			{
				//log.debug("is Object", obj);
				returnObj = processObject(obj, returnObj);
				
			}
			else if( obj is Array )
			{
				//log.debug("IS ARRAY");
				returnObj = processArray(obj, returnObj);				
			}
			
			return returnObj;
		}
		
		public function processObject( obj:Object, returnObj:Object ):Object
		{
			var className:String = "";
			var value:Object;
			
			for each (var items:String in obj)
			{
				className = ObjectTools.getImmediateClassPath(obj[items]);
				className = className == null ? items : className;
				value = obj[items];
				//log.debug("className/Value", className, value);
				returnObj[items] = className + "::" + value;
			}
			
			return returnObj;
		}
		
		public function processArray( obj:Object, returnObj:Object ):Object
		{
			var className:String = "";
			var value:Object;
			
			for(var i:Number=0;i<obj.length;i++)
			{
				className = ObjectTools.getImmediateClassPath(obj[i]);
				className = className == null ? String(i) : className;
				value = obj[i];
				returnObj[i] = className + "::" + value;
			}
				
			return returnObj;
		}
		
		public function processDictionary( obj:Object, returnObj:Object ):Object
		{
			var className:String = "";
			var value:Object;
			var diCounter:Number = 0;
			for each( var diItem:Object in obj)
			{
				className = ObjectTools.getImmediateClassPath(diItem);
				className = className == null ? "dictionary Item" : className;
				
				value = diItem;
				//log.debug("className/Value", className, value);
				returnObj[String(diCounter)] = className + "::" + value;
				diCounter++;
			} 
			
			return returnObj;			
		}
		
		/*
		There are 2 parts to inspection:
		
		1. look at the displayObjects
		2. look for arrays/objects in the describeType object
		*/
		
		public function inspectObject(target:String):String
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
				if( (obj.hasOwnProperty("numChildren") && obj.numChildren == 0) || obj is DisplayObject == false) return "";
				
				// the currentTarget should be correct now.  Create root node
				var className:String = getQualifiedClassName(obj).split("::")[1] == undefined ? getQualifiedClassName(obj) : getQualifiedClassName(obj).split("::")[1]
				returnList = "<" + currentTargetPath + " label=\"" + currentTargetPath + " (" + className + ")\" mc=\"" + currentTargetPath + "\" t=\"2\" >";
				
				// check for displayObject
				if( obj is DisplayObject ) 
				{
					buildDisplayList(obj);
					buildObjectList(obj);
				}
				
				returnList += "</" + currentTargetPath + ">";				
			}catch(e:Error)
			{
				log.error("inspect object error: " + currentTargetPath, e.message);
			}
			
			return returnList;		
		}
		
		protected function buildDisplayList(obj:Object):void
		{
			try
			{
				for(var i:Number=0;i<obj.numChildren;i++)
				{
					var container:DisplayObject = obj.getChildAt(i);
					var name:String = container.name;
					var className:String = getQualifiedClassName(container).split("::")[1];
					var mc:String = currentTargetPath + "." + name;
					// add to the return string
					addToReturnList(name, className, mc);
				}
			}catch(e:Error)
			{
				log.debug("buildDisplayList error", e.message);
			}
		}
		
		/**
		 * @notes I'd meant to show "Objects" in the treeview as well
		 * @param obj
		 * 
		 */		
		protected function buildObjectList(obj:Object):void
		{
			var xml:XML = describeType(obj);
			
			for each(var item:XML in xml.variable)
			{
				try
				{
					if( item.@type == "Object" || item.@type == "Array" || item.@type == "Dictionary" )
					{
						var className:String = item.@type.split("::")[1];
						className = className == null ? item.@type : className;
						var name:String = item.@name;
						var mc:String = currentTargetPath + "." + name;
						addToReturnList(name, className, mc, 0);
					}
					
				}catch(e:Error)
				{
					log.error("getProperties error (" + item.@name  + ")", e.message);
					continue;
				}
			}
		}
		
		protected function addToReturnList(name:String, className:String, mc:String, type:Number=2):void
		{
			// <nodeName label=nodeName mc=mc t=2 />
			name = name.split(" ").join("_");
			returnList += "<" + name + " label=\"" + name + " (" + className + ")\" mc=\"" + mc + "\" t=\""+ type + "\" />";
		}
		
		public function parseObjectToString(p_obj:Object, p_nodeName:String="root"):String
		{
			var str:String = "<" + p_nodeName + ">";
			for(var items:String in p_obj)
			{
				if(typeof(p_obj[items]) == "object")
				{
					str += parseObjectToString(p_obj[items], items);
				}else
				{
					var nodeValue:* = p_obj[items];
					if(typeof(nodeValue) != "boolean" && typeof(nodeValue) != "number") nodeValue = encode(p_obj[items]);
					str += "<" + items + ">" + nodeValue + "</" + items + ">";
				}
			}
			str += "</" + p_nodeName + ">";
			return str;
		}
		
		protected function encode(p_str:String):String
		{
			for(var i:Number=0;i<strings.length;i++)
			{
				p_str = p_str.split(strings[i].from).join(strings[i].replace);
			}
			
			return p_str;
		}
	}
}