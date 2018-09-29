import hxd.Math;
import hxd.Pad;
import h3d.Vector;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import hxd.fmt.hmd.Library;
import h3d.scene.Object;
import h3d.scene.World;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2BodyType;

using extensions.ObjectExtensions;
using extensions.LibraryExtensions;

class Ship {
    var game : Game;
    var model : Library;
    var object : Object;
    var body : B2Body;

    public function new (game : Game) {
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

        var fixture_def = new B2FixtureDef();
        fixture_def.density = 1.0;
        fixture_def.shape = new B2CircleShape(1.0);
        body.createFixture(fixture_def);

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
                stick.x = stick.x * (5.0 * dt);
                stick.y = -stick.y * (5.0 * dt);
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

    function mod_angle(input:B2Vec2, wrapAngle:Float):Float {
        return ((Math.atan2(input.y, input.x) + wrapAngle) % wrapAngle) + (Math.PI * 0.5);
    }
}