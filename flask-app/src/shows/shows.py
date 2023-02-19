from flask import Blueprint, request, jsonify, make_response
from src import db

shows = Blueprint('shows', __name__)


# Get all shows from the DB
@shows.route('/shows', methods=['GET'])
def get_shows():
    cursor = db.get_db().cursor()
    cursor.execute('select * from TVShow')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get customer detail for customer with particular showID
@shows.route('/shows/<showid>', methods=['GET'])
def get_show(showid):
    cursor = db.get_db().cursor()
    cursor.execute('select * from TVShow where TVShowID = {}'.format(showid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@shows.route('/add', methods=['PUT'])
def add_show():
    query = 'insert into TVShow (title, description, IMDBRating, image) ' \
            'values ({}, {}, {}, {})'
    title = request.form.get('TitleInput')
    description = request.form.get('DescInput')
    rating = request.form.get('RatingInput')
    image = request.form.get('ImageInput')
    cur = db.get_db().cursor()
    cur.execute(query.format(title, description, rating, image))
    db.get_db().commit()
    db.session.commit()


@shows.route('/delete', methods=['DELETE'])
def delete_show():
    query = 'DELETE FROM TVShow WHERE ShowID = {}'
    showid = request.form.get('ShowID')
    cur = db.get_db().cursor()
    cur.execute(query.format(showid))
    db.get_db().commit()
    db.session.commit()


@shows.route('/update', methods=['POST'])
def update_show():
    query = 'UPDATE TVShow SET title = {}, description = {}, IMDBRating = {}, image = {} WHERE ShowID = {}'
    title = request.form.get('TitleInput')
    description = request.form.get('DescInput')
    rating = request.form.get('RatingInput')
    image = request.form.get('ImageInput')
    showid = request.form.get('ShowID')
    cur = db.get_db().cursor()
    cur.execute(query.format(title, description, rating, image, showid))
    db.get_db().commit()
    db.session.commit()


@shows.route('/comments/<showid>', methods=['GET'])
def get_comments(showid):
    cursor = db.get_db().cursor()
    cursor.execute(
        'select r.Rating as Rating, r.Comment as Comment, CONCAT(c.first, SPACE(1), c.last) as Critic, r.Date as Date ' +
        'from TVRating r JOIN Critic c ON r.CriticID = c.CriticID ' +
        'where ShowID = {}'.format(showid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@shows.route('/addComment', methods=['PUT'])
def add_comment():
    query = 'insert into TVRating (ShowID, CriticID, Rating, Comment) ' \
            'values ({}, {}, {}, {})'
    showid = request.form.get('ShowID')
    criticid = request.form.get('CriticID')
    rating = request.form.get('RatingInput')
    comment = request.form.get('CommentInput')
    cur = db.get_db().cursor()
    cur.execute(query.format(showid, criticid, rating, comment))
    db.get_db().commit()
    db.session.commit()
