# Frame by Frame
```
The College of New Jersey
CSC-470 Cloud Computing
Ruby Project
```
## Introduction
*Frame by Frame* is a web application where many anonymous users can collaborate to create frame animations. All users draw on a single canvas which is routinely saved as a frame to be used in generating an animation. After a frame is saved it is ‘onioned’ onto a new canvas as transparent layer helping users draw cohesive animations. Users will also have access to a chat system shared between the community. In addition to the public area users can create private drawing and share them with their friends via shared URLs in emails.

## The Web Server
The web server is built with the Ruby on Rails framework and hosted on a virtual server. The server uses many Amazon AWS services for affordability and scalability. Follow the instructions below to put together a development environment for the web server.

### Setting up a Development Environment

#### 1. Install Ruby
The first thing to do is to install the latest version of Ruby, which is 2.2.1 at the time of writing this README. The method to install Ruby depends on which operating system you are using. Refer to [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) for more details.

#### 2. Install Rails
The easiest way to install [Ruby on Rails](http://rubyonrails.org/) is through [RubyGems](https://rubygems.org/). Since version 1.9 Ruby comes with RubyGems. If you are using an older version of Ruby then you will need to install RubyGems manually. To install Rails simply run the command `gem install rails` in a terminal.

#### 3. Install the Databases (SQLite and MySQL)
Ruby on Rails is a web development framework that follows an MVC (models, views, controllers) pattern. Rails stores all of its models inside a database. By default new Rails applications are set up to work with SQLite for its small footprint and ease of use. In production this server will be backed by an AWS RDS database running MySQL. Although we can set up a development environment with MySQL, it is much easier and cleaner if it is set up with SQLite instead. At the moment MySQL is not needed for development.

SQLite is shipped with many Unix-like operating systems. To check if SQLite is installed try running the following command
```
sqlite3 --version
 >> 3.8.8.3 2015-02-25 13:29:11
```
If there is an error then you will need to install SQLite. It is normally found in the OSes package manager on Unix-like systems. All other systems should refer to the [SQLite download page](http://www.sqlite.org/download.html).

#### 4. Clone the Git Repository
Clone the git repository to your local machine with the following command:
```
git clone git@github.com:mjudy94/frame-by-frame.git path/to/project/directory
```

#### 5. Initializing Transcrypt
Transcrypt is a nifty tool that automatically encrypts sensitive files in the git repository upon commit using SSL encryption. This is useful for storing secret username and password strings for authentication with resources such as a remote database or AWS. Transcrypt needs to be initialized on all development machines with the proper cipher and password. Ask [Kenny Ruddick](https://github.com/KenRud) for the initialization password.

```
cd <root of git clone>
./transcrypt -c aes-256-cbc -p <enter password here>
```

#### 5. Build the Database Tables
After cloning the repository for the first time you may need to build the database and its associated tables because the database is not committed. Fortunately Rails provides a set of commands for managing the database. Navigate to the `webserver` directory (the root of the Rails server) and run the following command to ensure that the database has been created and up to date.
```
bin/rake db:create db:migrate
```

#### 6. Run the Rails Web Server
To run the server simply navigate to `webserver` directory and run the following command:
```
bin/rails server
```
This will start up the server on your local machine at port 3000. To interact with the application navigate your web browser to http://localhost:3000.

#### 7. Installation Notes
If you are running a Linux system you may need to install a few other packages other than the ones mentioned. For example, Rails may need the development header files of SQLite. If any errors come up be sure to read them to pinpoint what is missing.

### Deployment to the Production Server
Deployment of the Rails web application relies on several different technologies that enable fast and stable deployment.

#### Capistrano
Capistrano is a tool for automating remote deployment to a production server. This tool is used to push new releases to the production server, install the dependencies, and restart the server. To push a new release run the following command from the root of the rails project.
```
bundle exec cap production deploy
```

#### Phusion Passenger
Phusion Passenger is an application server for running web applications. It runs our Rails web application, automatically spawning multiple processes as there are more incoming requests. This is already set up on the server and Capistrano handles restarting Passenger after a new deployment. If Passenger needs to be initiated again in case the server is shut down or rebooted, run the following commands on the server:
```
cd /var/www/frame_by_frame_app/current
su -
passenger start --daemonize --user deploy
```
