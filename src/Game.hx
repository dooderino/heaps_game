import h3d.Vector;
import h2d.Flow;
import h2d.Text;
import hxd.Pad;
import h3d.scene.*;
import box2D.dynamics.*;
import box2D.common.math.B2Vec2;

class Game extends hxd.App {
	public var pad : Pad;
	public var tf : Text;
	public var flow : Flow;
	public static var physics_world(default, null) : B2World;
	public var world : World;
	public var ship : Ship;

	static var physics_time_step : Float = 1.0 / 60.0;
	static var velocity_iterations : Int = 6;
 	static var position_iterations : Int = 2;

	override function new(physicsWorld:B2World) {
		wantedFPS = 60.0;		
		physics_world = physicsWorld;

		super();
	}

	override function init() {
		world = new h3d.scene.World(64, 128, s3d);

		ship = new Ship(this);
		s3d.camera.pos.set(0, 200, 0);

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
		s3d.lightSystem.ambientLight.set(0.8, 0.8, 0.8);

		var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.power = 5;
		shadow.color.setColor(0x301030);

	    flow = new h2d.Flow(s2d);
	    flow.padding = 20;
	    flow.isVertical = true;

	    tf = new h2d.Text(hxd.res.DefaultFont.get(), flow);
	    tf.text = "Waiting for pad...";

	    Pad.wait(on_pad);
	}

	function on_pad(p : Pad) {
		pad = p;
		tf.remove();
		p.onDisconnect = on_pad_disconnect;
	}

	function on_pad_disconnect() {
	    tf = new h2d.Text(hxd.res.DefaultFont.get(), flow);
	    tf.text = "Waiting for pad...";
		Pad.wait(on_pad);
	}

	public function get_world() : World {
		return world;
	}

	public function get_physics_world() : B2World {
		return physics_world;
	}

	override function update(dt:Float) {
		ship.update_physics(pad, dt);
		
		physics_world.step(
			physics_time_step, 
			velocity_iterations, 
			position_iterations);

		ship.update(dt);

		var ship_object = ship.get_object();
		s3d.camera.target = new Vector(ship_object.x, ship_object.y, ship_object.z);
	}

	override function render(e:h3d.Engine) {
		s2d.render(e);
		s3d.render(e);
	}

	static function main() {
		hxd.Res.initEmbed();

		var physicsWorld : B2World = new B2World(new B2Vec2(0.0, 0.0), true);

		new Game(physicsWorld);
	}
}
