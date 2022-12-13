from flask import Blueprint, jsonify, make_response
from src import db


seasons = Blueprint('seasons', __name__)


# Get customer detail for customer with particular movieID
@seasons.route('/<movieid>', methods=['GET'])
def get_season(movieid):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Season where ShowID = {}'.format(movieid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
