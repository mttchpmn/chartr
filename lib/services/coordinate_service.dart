import 'package:chartr/models/grid_ref.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

class CoordinateService {
  final String _nztmProjectionDefinition =
      "+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs";

  GridRef latLngToGrid(LatLng latLng) {
    var baseProjection = Projection.get('EPSG:4326')!;

    var nztmProjection = Projection.get("EPSG:2193") ??
        Projection.add("EPSG:2193", _nztmProjectionDefinition);

    var point = Point(
      x: latLng.longitude,
      y: latLng.latitude,
    );

    var result = baseProjection.transform(nztmProjection, point);

    return GridRef(result.x.round(), result.y.round());
  }

  LatLng gridRefToLatLng(GridRef gridRef) {
    var point =
        Point(x: gridRef.eastings.toDouble(), y: gridRef.northings.toDouble());

    var baseProjection = Projection.get("EPSG:2193") ??
        Projection.add("EPSG:2193", _nztmProjectionDefinition);

    var latLngProjection = Projection.get('EPSG:4326')!;

    var result = baseProjection.transform(latLngProjection, point);

    return LatLng(result.y, result.x);
  }
}
