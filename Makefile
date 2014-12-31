owner_points/owner_points_pick.geojson: owner_points/owner_points.geojson
	geojson-pick SSL < owner_points/owner_points.geojson > owner_points/owner_points_pick.geojson

owner_points/owner_points.geojson: owner_points/Owner_Points.shp
	ogr2ogr -f GeoJSON owner_points/owner_points.geojson owner_points/Owner_Points.shp

owner_points/Owner_Points.shp: owner_points/owner_points.zip
	unzip -d owner_points owner_points/owner_points.zip

owner_points/owner_points.zip: owner_points
	wget http://opendata.dc.gov/datasets/2a70832d0e9d448fb3775a876c9ffb00_27.zip -O owner_points/owner_points.zip
	touch $@

owner_points:
	mkdir owner_points
