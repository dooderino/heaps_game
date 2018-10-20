import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import IGameObject;
import IGameObject.ObjectType;

class ContactListener extends B2ContactListener {

    public override function beginContact(contact:B2Contact):Void {
        var a = cast(contact.getFixtureA().getBody().getUserData(), IGameObject);
        var a_type = a.get_object_type();
        var a_disposable = cast(a, IDisposable);

        var b = cast(contact.getFixtureB().getBody().getUserData(), IGameObject);
        var b_type = b.get_object_type();
        var b_disposable = cast(b, IDisposable);

        if (a_type == ObjectType.Ship && b_type == ObjectType.Star) {
            b_disposable.needs_disposal = true;
        }
    }
	
	public override function endContact(contact:B2Contact):Void {
    }
}