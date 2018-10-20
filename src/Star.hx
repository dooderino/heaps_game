import h3d.Engine;
import h2d.Graphics;
import h3d.Camera;
import box2D.dynamics.B2Fixture;
import hxd.Math;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import hxd.fmt.hmd.Library;
import h3d.scene.Object;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2BodyType;
import IGameObject;
import IGameObject.ObjectType;
import IDisposable.IDisposable;

using extensions.ObjectExtensions;
using extensions.LibraryExtensions;

class Star implements IGameObject
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


    public function get_body():B2Body {
        return body;
    }

    public function new (game : Game, x:Float, y:Float) {
        needs_disposal = false;
        this.game = game;
        var world = game.get_world();
        var physics_world = game.get_physics_world();

        model = hxd.Res.models.star.toHmd();
		object = model.makeObject();
        object.setPosition(x, 0, y);

		if (model.HasVertexColors()) {
			object.UseVertexColor();
		}

		var body_def : B2BodyDef = new B2BodyDef();
        body_def.position = new B2Vec2(x,y);
		body_def.active = true;
		body_def.type = B2BodyType.STATIC_BODY;
		body = physics_world.createBody(body_def);
        body.setUserData(this);

        var fixture_def = new B2FixtureDef();
        fixture_def.density = 1.0;
        fixture_def.shape = new B2CircleShape(2.0);
        fixture = body.createFixture(fixture_def);

		world.addChild(object);
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

    public function get_object():Object {
        return object;
    }

    public function update(dt : Float) {
   }

    function mod_angle(input:B2Vec2, wrapAngle:Float):Float {
        return ((Math.atan2(input.y, input.x) + wrapAngle) % wrapAngle) + (Math.PI * 0.5);
    }
}
