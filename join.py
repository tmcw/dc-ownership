import json, csv

with open('output.csv') as csvfile:
    index = {row['ssl']: row for row in csv.DictReader(csvfile)}
    gj = json.load(open('owner_points_pick.geojson'))
    gj['features'] = filter(lambda f: f['properties']['SSL'] in index, gj['features'])
    for feature in gj['features']:
        feature['properties'] = index[feature['properties']['SSL']]
    json.dump(gj, open('owner_points_joined.geojson', 'w'))
