import h3d.Engine;
import h3d.Camera;
import box2D.dynamics.B2Fixture;
import h2d.Graphics;
import hxd.Math;
import hxd.Pad;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import hxd.fmt.hmd.Library;
import h3d.scene.Object;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2BodyType;
import IDisposable.IDisposable;
import IGameObject;
import IGameObject.ObjectType;

using extensions.ObjectExtensions;
using extensions.LibraryExtensions;

class Ship implements IGameObject 
           implements IDisposable {
    var game : Game;
    var model : Library;
    var object : Object;
    var body : B2Body;
    var fixture : B2Fixture;
    var needs_delete:Bool;
    public var needs_disposal(get, set):Bool;

    public function get_needs_disposal():Bool {
        return needs_delete;
    }

    public function set_needs_disposal(value:Bool):Bool {
        return needs_delete = value;
    }

    public function get_object_type():ObjectType {
        return ObjectType.Ship;
    }

    public function new (game : Game) {
        needs_delete = false;
        this.game = game;
        var world = game.get_world();
        var physics_world = game.get_physics_world();

        model = hxd.Res.models.rocket_ship.toHmd();
		object = model.makeObject();

		if (model.HasVertexColors()) {
			object.UseVertexColor();
		}

		var body_def : B2BodyDef = new B2BodyDef();
		body_def.active = true;
		body_def.type = B2BodyType.DYNAMIC_BODY;
		body = physics_world.createBody(body_def);
        body.setUserData(this);

        var fixture_def = new B2FixtureDef();
        fixture_def.density = 1.0;
        fixture_def.shape = new B2CircleShape(4.0);
        fixture = body.createFixture(fixture_def);

		world.addChild(object);
    }

    public function get_object():Object {
        return object;
    }

    public function update_physics(pad : Pad, dt : Float) {
        if (pad != null && pad.connected) {
            var stick = new B2Vec2(pad.xAxis, pad.yAxis);
            var angle = mod_angle(stick, 2 * Math.PI);
            body.setAngle(angle);

            if (stick.length() > 0.5) {
                stick.multiply(1.0 / stick.length());
                stick.x = stick.x * (15.0 * dt);
                stick.y = -stick.y * (15.0 * dt);
                body.setLinearVelocity(stick);
           } else {
                stick.multiply(1.0 / stick.length());
                stick.x = stick.x * (1.0 * dt);
                stick.y = -stick.y * (1.0 * dt);
                body.setLinearVelocity(stick);
           }
       }
    }

    public function update(dt : Float) {
        var angle = body.getAngle();
        var position = body.getPosition();
        object.setRotation(0, angle, 0);
        object.setPosition(position.x, 0, position.y);
    }

   public function render(camera: Camera, graphics:Graphics, engine:Engine) {
        var center = body.getPosition();
        var ss_center = camera.project(center.x, 0, center.y, engine.width, engine.height);
        var radius = fixture.getShape().m_radius*9;
        graphics.beginFill(0x00FF00, 0.5);
        graphics.lineStyle(1, 0xFF00FF);
        graphics.drawCircle(ss_center.x, ss_center.y, radius);
        graphics.endFill();
    }

    function mod_angle(input:B2Vec2, wrapAngle:Float):Float {
        return ((Math.atan2(input.y, input.x) + wrapAngle) % wrapAngle) + (Math.PI * 0.5);
    }
}