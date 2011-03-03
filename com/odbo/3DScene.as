package com.odbo{
//	import com.toky.BtnCamera;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class 3DScene extends Sprite
	{
		public var viewport:Viewport3D;
		public var renderer:BasicRenderEngine;
		public var scene:Scene3D;
		public var camera:Camera3D;
		public var dae:DAE;
		public var cm:ColorMaterial;
		public var holder:DisplayObject3D;
		public var cameraBtn:BtnCamera;
		
		public function 3DScene() {
			init();
		}
		
		private function init() {
			//basic scene stuff
			viewport = new Viewport3D(900, 650, true,false);
			addChild(viewport);
			
			renderer = new BasicRenderEngine();
			scene = new Scene3D();
			camera = new Camera3D(holder, 15, 100);
			camera.z = -50;	
			
			//COLOR MATERIAL
			cm = new ColorMaterial(0xcccccc, .85, true);
			
			//DAE
			dae = new DAE();
			dae.load("pulitzer.dae", new MaterialsList({all:cm}));
			
			holder = new DisplayObject3D();
			holder.addChild(dae);
			
			holder.rotationX = 90;
			holder.rotationY = 45;
			scene.addChild(holder);
			stage.addEventListener(Event.ENTER_FRAME, renderStuff);
			
			//SETUP BUTTON
			cameraBtn = new BtnCamera(camera);
			addChild(cameraBtn);
			
		}
		
		private function renderStuff(e:Event) {
			renderer.renderScene(scene,camera,viewport,true);
		}	
	}
}

