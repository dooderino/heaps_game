package extensions;

import hxd.fmt.hmd.Library;

class LibraryExtensions {
    public static function HasVertexColors(library:Library):Bool {
        return library.header.geometries.filter(
            function(g) return g.vertexFormat.filter(
                function(f) return f.name == "color").length > 0).length > 0;
    }
}