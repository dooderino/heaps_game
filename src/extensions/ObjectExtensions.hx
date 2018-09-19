package extensions;

import h3d.shader.VertexColor;
import h3d.shader.VertexColorAlpha;
import h3d.scene.Object;

class ObjectExtensions {
    public static function UseVertexColor( object:Object ) {
        for( mesh in object.getMeshes()) {
            mesh.material.mainPass.addShader(new VertexColor());
            mesh.material.mainPass.culling = None;
   			mesh.material.getPass("shadow").culling = None;
        }
    }

    public static function UseVertexColorAlpha( object:Object ) {
        for( material in object.getMaterials() ) {
            material.mainPass.addShader(new VertexColorAlpha());
            material.mainPass.culling = None;
			material.getPass("shadow").culling = None;
        }
    }
}