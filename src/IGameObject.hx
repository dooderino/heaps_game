enum ObjectType {
    Ship;
    Star;
}

interface IGameObject {
    public function get_object_type():ObjectType;
}