import h3d.scene.*;
using extensions.ObjectExtensions;
using extensions.LibraryExtensions;

class Main extends hxd.App {

	override function init() {
		
		var model = hxd.Res.models.test.icosahedron.toHmd();
		var obj = model.makeObject();
		s3d.addChild(obj);

		if (model.HasVertexColors()) {
			obj.UseVertexColor();
		}

		s3d.camera.pos.set( -20, -5, 20);
		s3d.camera.target.z += 1;

		// add lights and setup materials
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		s3d.lightSystem.ambientLight.set(0.8, 0.8, 0.8);

		var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.power = 5;
		shadow.color.setColor(0x301030);

		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
