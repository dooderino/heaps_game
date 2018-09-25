import box2D.dynamics.B2TimeStep;
import h3d.scene.*;
import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

using extensions.ObjectExtensions;
using extensions.LibraryExtensions;

class Main extends hxd.App {
	public static var physics_world(default, null) : B2World;
	public var world : World;

	static var physics_time_step : Float = 1.0 / 60.0;
	static var velocity_iterations : Int = 6;
 	static var position_iterations : Int = 2;

	override function new(physicsWorld:B2World) {
		wantedFPS = 60.0;		
		physics_world = physicsWorld;

		super();
	}

	override function init() {
		var world = new h3d.scene.World(64, 128, s3d);
		var model = hxd.Res.models.test.icosahedron.toHmd();
		var obj = model.makeObject();
		world.addChild(obj);

		if (model.HasVertexColors()) {
			obj.UseVertexColor();
		}

		s3d.camera.pos.set( -20, -5, 20);
		s3d.camera.target.z += 1;

		var particles = new h3d.parts.GpuParticles(world);
		var group = particles.addGroup();
		group.size = 0.2;
		group.gravity = 0;
		group.speed = 0.01;
		group.life = 100;
		group.emitAngle = 0;
		group.nparts = 1000;
		group.emitMode = CameraBounds;
		particles.volumeBounds = h3d.col.Bounds.fromValues( -20, -20, 15, 40, 40, 40);

		// add lights and setup materials
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		s3d.lightSystem.ambientLight.set(0.8, 0.8, 0.8);

		var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.power = 5;
		shadow.color.setColor(0x301030);

		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	override function update(dt:Float) {
		physics_world.step(
			physics_time_step, 
			velocity_iterations, 
			position_iterations);

		
	}

	override function render(e:h3d.Engine) {
		s2d.render(e);
		s3d.render(e);
	}

	static function main() {
		hxd.Res.initEmbed();

		var physicsWorld : B2World = new B2World(new B2Vec2(0.0, -9.8), true);

		new Main(physicsWorld);
	}
}
