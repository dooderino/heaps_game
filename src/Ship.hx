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
    var model : Library;
    var object : Object;
    var body : B2Body;

    public function new (main : Main) {
        var world = main.get_world();
        var physics_world = main.get_physics_world();

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

    public function update_physics() {
        body.setLinearVelocity(new B2Vec2(0,10));
    }

    public function update(dt : Float) {
        var position = body.getPosition();
        object.setPosition(position.x, 0, position.y);
    }
}