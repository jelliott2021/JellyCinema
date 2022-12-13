# Jelly Cinema Project

Welcome to Jelly Cinema, a movie rating website built using MySQL and Flask. This project features three user types:

### User
Users are able to view movies and shows and reviews written by critics. They do not have any additional permissions
within the website.

### Critic
Critics are users who are able to rate movies and write reviews.

### Admin
Admins are responsible for managing the website, including adding and removing movies and shows, managing user and
critic accounts

# Video Overview
https://clipchamp.com/watch/ARKx7wZKvtc


# Getting Started

You will need to install Flask and MySQL on your system. Please see the project's documentation for
instructions on how to do this.

We hope you enjoy using Jelly Cinema!

# Setup containers

This repo contains a boilerplate setup for spinning up 2 docker containers:

1. A MySQL 8 container for obvious reasons
2. A Python Flask container to implement a REST API

## How to setup and start the containers

**Important** - you need Docker Desktop installed

1. Clone this repository.
2. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL.
3. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for
   the `jelly` user.
4. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.
5. Build the images with `docker compose build`
6. Start the containers with `docker compose up`. To run in detached mode, run `docker compose up -d`.

## For setting up a Conda Web-Dev environment:

1. `conda create -n webdev python=3.9`
2. `conda activate webdev`
3. `pip install flask flask-mysql flask-restful cryptography flask-login`

# Contributing

We welcome contributions to this project! If you are interested in contributing, please follow these guidelines:

1. Before making any changes, open an issue to discuss the proposed changes with the maintainers of the project. This
   will help ensure that your changes are in line with the project's goals and direction.
2. Fork the project and make your changes on a new branch.
3. Test your changes to ensure that they are working as intended and do not introduce any new bugs.
4. Open a pull request to the project's develop branch.
5. The maintainers will review your changes and provide feedback. Once your changes have been reviewed and any necessary
   changes have been made, the maintainers will merge your changes into the develop branch.

# Changelog

### Version 1.0 12/12/2022
#### Initial release of the project.
#### Features include:
- Three personas: User, Critic, Admin
- Support for multiple HTTP methods (e.g. GET, POST, PUT, DELETE)
- Endpoints for different resources (e.g. /user, /movie, /season)
- Support for sending and receiving data in JSON




