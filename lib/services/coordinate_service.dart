import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

class CoordinateService {
  GridRef latLngToGrid(LatLng latLng) {
    var baseProjection = Projection.get('EPSG:4326')!;

    var nztmDefinition =
        "+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs";
    var nztmProjection = Projection.get("EPSG:2193") ??
        Projection.add("EPSG:2193", nztmDefinition);

    var point = Point(
      x: latLng.longitude,
      y: latLng.latitude,
    );

    var result = baseProjection.transform(nztmProjection, point);

    return GridRef(result.x.round(), result.y.round());
  }
}

class GridRef {
  final int eastings;
  final int northings;

  GridRef(this.eastings, this.northings);
}
