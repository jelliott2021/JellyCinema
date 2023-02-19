from flask import Blueprint, request, jsonify, make_response
from src import db

users = Blueprint('users', __name__)


# Get all users from the DB
@users.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('select * from User')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get customer detail for customer with particular userID
@users.route('/users/<userID>', methods=['GET'])
def get_user(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from User where UserID = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@users.route('/update', methods=['POST'])
def update_user():
    query = 'UPDATE User SET first = {}, last = {}, email = {} WHERE UserID = {}'
    first = request.form.get('FirstInput')
    last = request.form.get('LastInput')
    email = request.form.get('EmailInput')
    userid = request.form.get('UserID')
    cur = db.get_db().cursor()
    cur.execute(query.format(first, last, email, userid))
    db.get_db().commit()
    db.session.commit()


@users.route('/add', methods=['PUT'])
def add_user():
    query = 'insert into User (first, last, email, birthdate, password) ' \
            'values({}, {}, {}, {}, {})'
    first = request.form.get('FirstInput')
    last = request.form.get('LastInput')
    email = request.form.get('EmailInput')
    birthdate = request.form.get('BirthdayInput')
    password = request.form.get('PasswordInput')
    cur = db.get_db().cursor()
    cur.execute(query.format(first, last, email, birthdate, password))
    db.get_db().commit()
    db.session.commit()
