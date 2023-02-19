from flask import Blueprint, request, jsonify, make_response
from src import db

movies = Blueprint('movies', __name__)


# Get all movies from the DB
@movies.route('/movies', methods=['GET'])
def get_movies():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Movie')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get customer detail for customer with particular movieID
@movies.route('/movies/<movieid>', methods=['GET'])
def get_movie(movieid):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Movie where MovieID = {}'.format(movieid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@movies.route('/add', methods=['PUT'])
def add_movie():
    query = 'insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID) ' \
            'values({}, {}, {}, {}, {}, {}, {}, null)'
    title = request.form.get('TitleInput')
    description = request.form.get('DescInput')
    runtime = request.form.get('TimeInput')
    trailer = request.form.get('TrailerInput')
    rating = request.form.get('RatingInput')
    date = request.form.get('DateInput')
    image = request.form.get('ImageInput')
    cur = db.get_db().cursor()
    cur.execute(query.format(title, runtime, date, rating, description, trailer, image))
    db.get_db().commit()
    db.session.commit()


@movies.route('/delete', methods=['DELETE'])
def delete_movie():
    query = 'DELETE FROM Movie WHERE MovieID = {}'
    movieid = request.form.get('MovieID')
    cur = db.get_db().cursor()
    cur.execute(query.format(movieid))
    db.get_db().commit()
    db.session.commit()


@movies.route('/update', methods=['POST'])
def update_movie():
    query = 'UPDATE Movie ' \
            'SET title = {}, runtime = {}, releaseDate = {}, IMDBRating = {}, description = {}, trailer = {}, image = {} ' \
            'WHERE MovieID = {}'
    title = request.form.get('TitleInput')
    runtime = request.form.get('TimeInput')
    releaseDate = request.form.get('DateInput')
    rating = request.form.get('RatingInput')
    description = request.form.get('DescInput')
    trailer = request.form.get('TrailerInput')
    image = request.form.get('ImageInput')
    movieid = request.form.get('MovieID')
    cur = db.get_db().cursor()
    cur.execute(query.format(title, runtime, releaseDate, rating, description, trailer, image, movieid))
    db.get_db().commit()
    db.session.commit()


@movies.route('/comments/<movieid>', methods=['GET'])
def get_comments(movieid):
    cursor = db.get_db().cursor()
    cursor.execute(
        'select r.Rating as Rating, r.Comment as Comment, CONCAT(c.first, SPACE(1), c.last) as Critic, r.Date as Date ' +
        'from MovieRating r JOIN Critic c ON r.CriticID = c.CriticID ' +
        'where MovieID = {}'.format(movieid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@movies.route('/addComment', methods=['PUT'])
def add_comment():
    query = 'insert into MovieRating (MovieID, CriticID, Rating, Comment) ' \
            'values ({}, {}, {}, {})'
    movieid = request.form.get('MovieID')
    criticid = request.form.get('CriticID')
    rating = request.form.get('RatingInput')
    comment = request.form.get('CommentInput')
    cur = db.get_db().cursor()
    cur.execute(query.format(movieid, criticid, rating, comment))
    db.get_db().commit()
    db.session.commit()
