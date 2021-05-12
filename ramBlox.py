## @file

import config

import os, sys, re
import datetime as dt

import flask

app = flask.Flask(__name__)

app.run(debug=True, host=config.HOST, port=config.PORT)
