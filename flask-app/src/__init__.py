# Some set up for the application 

from flask import Flask
from flaskext.mysql import MySQL

# create a MySQL object that we will use in other parts of the API
db = MySQL()

def create_app():
    app = Flask(__name__)
    
    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'jelly'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_password.txt').readline()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'JellyCinema'  # Change this to your DB name

    # Initialize the database object with the settings above. 
    db.init_app(app)
    
    # Import the various routes
    from src.views import views
    from src.admins.admins import admins
    from src.critics.critics import critics
    from src.users.users import users
    from src.movies.movies import movies
    from src.shows.shows import shows
    from src.seasons.seasons import seasons

    # Register the routes that we just imported so they can be properly handled
    app.register_blueprint(views,       url_prefix='/view')
    app.register_blueprint(admins, url_prefix='/admin')
    app.register_blueprint(critics, url_prefix='/critic')
    app.register_blueprint(users, url_prefix='/user')
    app.register_blueprint(movies, url_prefix='/movie')
    app.register_blueprint(shows, url_prefix='/show')
    app.register_blueprint(seasons, url_prefix='/season')

    return app
