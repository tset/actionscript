/**
* ...
* @author Default
* @version 0.1
*/

package src {
	
	import flash.events.Event;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;		
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.*
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.materials.shaders.*;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.events.FileLoadEvent;
	
	
	public class DaeShadeMaterial extends Sprite{
		
		var view:BasicView;
		var matTypes:Array;
		var startMouseX:Number;
		var rot:rotateIcon;
		var daeFile:String;
		var daeMaterialName:String;
		
		
		//objects
		var dae:DAE;
		var plane:Plane;
		
		//simple materials
		var colorMat:ColorMaterial;
		var wireframeMat:WireframeMaterial;
		var compMat:CompositeMaterial;
		var rotateMat:MovieAssetMaterial;
		var movieAssetMat:MovieAssetMaterial;
		var bitmapAssetMat:BitmapAssetMaterial;
		
		
		//shadeMaterials
		var cellMat:CellMaterial;
		var lightMapData:BitmapData;
		var envMapMat:EnvMapMaterial;
		var flatShadeMat:FlatShadeMaterial;
		var goraudShadeMat:GouraudMaterial;
		var phongMat:PhongMaterial;
		
		//shaders
		var phongShader:PhongShader;
		var bumpMap:BitmapData;
		var phongShadedMat:ShadedMaterial;
		var goraudShader:GouraudShader;
		var goraudShadedMat:ShadedMaterial;
		
		//lights
		var pointLight:PointLight3D;
		
		public function DaeShadeMaterial() {
			
			daeFile = "collada/radiosity/bunnyBakeFrench2.dae";
			daeMaterialName = "radioRender2_jpg";
			
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			rot = new rotateIcon();
			
			view = new BasicView(0, 0, true,false, "FREECAMERA3D");
			addChild(view);
			
			view.camera.zoom = 1;
			view.camera.focus = 1100;
			view.camera.y = 120;
			view.camera.x = 80;
			view.camera.pitch(9);
			
			pointLight = new PointLight3D();
			pointLight.y = 0;
			pointLight.x = 150;
			pointLight.z = 300;	
			
			colorMat = new ColorMaterial(0x6F6F6F);			
			wireframeMat = new WireframeMaterial(0xFFFFFF);			
			
			compMat = new CompositeMaterial();
			compMat.addMaterial(colorMat);
			compMat.addMaterial(wireframeMat);	
			
			lightMapData = new Bitmap(new EnviroMap(0,0)).bitmapData;
			envMapMat = new EnvMapMaterial(pointLight, lightMapData, lightMapData, 0xFFCCDD);
			
			cellMat = new CellMaterial(pointLight, 0xFAAAAAA, 0xFFFFFF, 15);
			
			bitmapAssetMat = new BitmapAssetMaterial("FlashTexBitmap");
			bitmapAssetMat.smooth = true;
			movieAssetMat = new MovieAssetMaterial("FlashTex2", false, true);
			movieAssetMat.smooth = true;
			movieAssetMat.tiled = true;
			flatShadeMat = new FlatShadeMaterial(pointLight, 0x9EF1FA , 0x6F6F6F);
			goraudShadeMat = new GouraudMaterial(pointLight, 0x9EF1FA , 0x6F6F6F);
			phongMat = new PhongMaterial(pointLight, 0xE7FCFE , 0x6F6F6F, 1);
			
			matTypes = new Array(["Goraud", goraudShadeMat], ["Cell", cellMat], ["Environmental Map", envMapMat], ["Phong", phongMat],["Composite Material", compMat], ["Wireframe", wireframeMat],["FlatShade", flatShadeMat], ["Bitmap Asset", bitmapAssetMat], ["Movie Asset", movieAssetMat]);
			
			dae = new DAE();
			dae.load(daeFile);
			dae.scale = 165;
			dae.pitch(90);
			dae.y = -60;
			dae.z = -720;
			dae.moveRight(170);			
			
			dae.addEventListener(Event.COMPLETE, daeLoadComplete);
			dae.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			view.scene.addChild(dae);			
			createButtons();
			
			rotateMat = new MovieAssetMaterial("RotateMat", true);
			rotateMat.smooth = true;
			rotateMat.doubleSided = true;
			
			plane = new Plane(rotateMat, 500, 500, 4, 4);
			plane.pitch(90);
			plane.y = -300;
			plane.z += 240;
			plane.x += 229;
			
			addEventListener(Event.ENTER_FRAME, enterFrameRender);
		}
		
		private function dragging(e:MouseEvent):void {
			if (mouseX>110) { 
				view.scene.addChild(plane);
				startMouseX = mouseX;
				stage.addEventListener(Event.ENTER_FRAME, dragAmount);
				trace("dragging");			
			}		
		}
		
		private function dragAmount(e:Event):void {
			rot.x = Math.floor(mouseX);
			rot.y = Math.floor(mouseY);
			var newMouseX:Number = (mouseX - startMouseX)/2;
			trace(newMouseX);
			dae.roll( -newMouseX * 0.8);
			plane.roll(newMouseX * 0.8);
			stage.addEventListener(MouseEvent.MOUSE_UP, noDragging); 
			startMouseX = mouseX;
			
		}
		
		private function noDragging(e:MouseEvent):void {
			view.scene.removeChild(plane);
			stage.removeEventListener(Event.ENTER_FRAME, dragAmount);
			stage.removeEventListener(MouseEvent.MOUSE_UP, noDragging);
		}		
		
		private function changeMaterial(e:MouseEvent):void {
			trace(e.target.material);
			trace(daeMaterialName);
			dae.replaceMaterialByName(e.target.material, daeMaterialName);			
		}
		
		private function loadProgress(e:ProgressEvent):void {
			loadText.text = "Loading Collada: " + Math.floor((e.bytesLoaded / e.bytesTotal) * 100) +"%";			
		}
		
		private function daeLoadComplete(e:Event):void {
			trace("loaded");
			removeChild(loadText);
			dae.replaceMaterialByName(bitmapAssetMat, daeMaterialName);
			addEventListener(MouseEvent.MOUSE_DOWN, dragging);
			view.singleRender();
		}
		
		private function enterFrameRender(e:Event):void {
			view.singleRender();
		}
		
		private function createButtons():void {
			
			for (var i:uint = 0; i < matTypes.length; i++) {
				var btn:Btn = new Btn();
				addChild(btn);
				btn.x = 70;
				btn.y = 40+ i*40;
				btn.btnTxt.text = matTypes[i][0];
				btn.btnTxt.mouseEnabled = false;
				btn.material = matTypes[i][1];
				trace(btn.material);
				btn.addEventListener(MouseEvent.CLICK, changeMaterial);
			}
		}
	}	
}
