from flask import Blueprint, request, jsonify, make_response
from src import db

critics = Blueprint('critics', __name__)


# Get all critics from the DB
@critics.route('/critics', methods=['GET'])
def get_critics():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Critic')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get customer detail for customer with particular criticID
@critics.route('/critics/<criticID>', methods=['GET'])
def get_critic(criticID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Critic where CriticID = {0}'.format(criticID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@critics.route('/update', methods=['POST'])
def update_user():
    query = 'UPDATE Critic SET first = {}, last = {}, email = {} WHERE CriticID = {}'
    first = request.form.get('FirstInput')
    last = request.form.get('LastInput')
    email = request.form.get('EmailInput')
    criticid = request.form.get('CriticID')
    cur = db.get_db().cursor()
    cur.execute(query.format(first, last, email, criticid))
    db.get_db().commit()
    db.session.commit()


@critics.route('/add', methods=['PUT'])
def add_critic():
    query = 'insert into Critic (first, last, email, birthdate, password) ' \
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
