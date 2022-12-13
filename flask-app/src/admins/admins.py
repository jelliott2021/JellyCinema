from flask import Blueprint, request, jsonify, make_response
from src import db


admins = Blueprint('admins', __name__)

# Get all admins from the DB
@admins.route('/admins', methods=['GET'])
def get_admins():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Admin')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer detail for customer with particular adminID
@admins.route('/admins/<adminID>', methods=['GET'])
def get_admin(adminID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Admin where AdminID = {0}'.format(adminID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@admins.route('/update', methods=['POST'])
def update_user():
    query = 'UPDATE Admin SET first = {}, last = {}, email = {} WHERE AdminID = {}'
    first = request.form.get('FirstInput')
    last = request.form.get('LastInput')
    email = request.form.get('EmailInput')
    adminid = request.form.get('AdminID')
    cur = db.get_db().cursor()
    cur.execute(query.format(first, last, email, adminid))
    db.get_db().commit()
    db.session.commit()


@admins.route('/add', methods=['PUT'])
def add_admin():
    query = 'insert into Admin (first, last, email, birthdate, password) ' \
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