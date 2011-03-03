/**
* ...
* @author Brad Roodt www.rustpunk.co.za
* @version 0.1
* 
* 1)Create a movie asset material, and set it's animated property to true
* 
* MovieAssetMaterial(linkageID, transparent, ANIMATED, createUnique, precise);
* 
* 2) If you use smooth on your material, then make sure that you set tiled to true, to prevent your machine from 
* freezing up when your model is at positioned at certain angles.
* 
* 3) Set up an EnterFrame listener to re-render your scene every frame.
* 
* 
*/



package com.odbo {
	
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.events.ProgressEvent;
	import flash.text.TextField;	
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.events.FileLoadEvent;

	public class aScene extends Sprite {
		
		var startMouseX:Number;
		var daeFile:String;
		var daeMaterialName:String;
		var view:BasicView;
		
		//objects
		var dae:Collada;
		var plane:Plane;
		
		//simple materials
		var rotateMat:MovieAssetMaterial;
		var movieAssetMat:MovieAssetMaterial;
		var aMaterialsList:MaterialsList;
	//	var aHolder:DisplayObject3D;
		
		var thisStage;
		
		function aScene(_scope:*)
		{
			thisStage = _scope;
			
			AnimateMovieAssetMaterial()
		};
		
		public function AnimateMovieAssetMaterial() {

			daeFile = "3D/bunnyBakeFrench2.dae";
			daeMaterialName = "radioRender2_jpg";
			
			thisStage.quality = StageQuality.HIGH;
			thisStage.scaleMode = StageScaleMode.NO_SCALE;
			thisStage.align = StageAlign.TOP_LEFT;
			
			view = new BasicView(0,0,true, false, "FREECAMERA3D");
			addChild(view);
			
			view.camera.zoom = 1;
			view.camera.focus = 500;
			view.camera.y = 120;
			view.camera.x = 80;
			view.camera.pitch(9);					
			
			movieAssetMat = new MovieAssetMaterial("FlashTex2", false, true);
			movieAssetMat.interactive = true;
			movieAssetMat.smooth = true;
			movieAssetMat.tiled = true;
		 	
			
			aMaterialsList = new MaterialsList();
			aMaterialsList.addMaterial(movieAssetMat, "all");
			
			dae = new Collada(daeFile, aMaterialsList);

			dae.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, daeLoadComplete);
			view.scene.addChild(dae);			
						
			rotateMat = new MovieAssetMaterial("RotateMat", true);
			rotateMat.smooth = true;
			rotateMat.doubleSided = true;
			
			plane = new Plane(rotateMat, 480, 480, 4, 4);
			plane.pitch(90);
			plane.y = -310;
			plane.z += 240;
			plane.x += 75;
			addEventListener(Event.ENTER_FRAME, animateTexture);
		}
		
		
		private function daeLoadComplete(e:Event):void {
			thisStage.addEventListener(MouseEvent.MOUSE_DOWN, dragging);
			dae.replaceMaterialByName(movieAssetMat, daeMaterialName);
			view.singleRender();
			
			//removeChild(thisStage.loadText);
		}
		
		private function animateTexture(e:Event):void {
			view.singleRender();
		}
		
		private function loadProgress(e:ProgressEvent):void {
			thisStage.loadText.text="Loading Collada: " + Math.floor((e.bytesLoaded / e.bytesTotal)*100) +"%";
		}
		
		private function dragging(e:MouseEvent):void {
			view.scene.addChild(plane);
			startMouseX = mouseX;
			stage.addEventListener(Event.ENTER_FRAME, dragAmount);
		}
		
		private function dragAmount(e:Event):void {
			var newMouseX:Number = (mouseX - startMouseX)/2;
			dae.yaw( -newMouseX * 0.8);
			plane.roll(newMouseX * 0.8);
			stage.addEventListener(MouseEvent.MOUSE_UP, noDragging); 
			startMouseX = mouseX;
			
		}
		
		private function noDragging(e:MouseEvent):void {
			view.scene.removeChild(plane);
			stage.removeEventListener(Event.ENTER_FRAME, dragAmount);
			stage.removeEventListener(MouseEvent.MOUSE_UP, noDragging);
		}
		
		
	}	
}
