import json
import logging
import os
from logging import INFO, getLogger


from concurrent_log_handler import ConcurrentRotatingFileHandler
from flask import Flask, jsonify, request
from flask_cors import CORS

from service.project_service import createProjectService, getProjectExecuationStatus, queryProjects, runProjectService
from service.user_service import (createUserService, loginService, queryAllUserService,
                                  setUserService)

current_dir = os.getcwd()
log_file = current_dir + os.sep + "logs" + os.sep + 'log.txt'

logger = getLogger(__name__)
formatter_log = logging.Formatter(
    '%(asctime)s - %(filename)s [line: %(lineno)d] [%(levelname)s] ----- %(message)s'
)
rotateHandler = ConcurrentRotatingFileHandler(log_file, "a", 512 * 1024, 5)
rotateHandler.setFormatter(formatter_log)
logger.addHandler(rotateHandler)
logger.setLevel(INFO)

app = Flask(__name__)
CORS(app, supports_credentials=True)


@app.route("/", methods=['GET'])
def test():
    return "Hello,IO"


@app.route("/login", methods=['POST'])
def login():
    """{"username":...,"password":...}
    """
    dic = loginService(request=request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/createuser", methods=['POST'])
def createUser():
    dic = createUserService(request=request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/setuser", methods=['POST'])
def setUser():
    dic = setUserService(request=request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/createproject", methods=['POST'])
def createProject():
    dic = createProjectService(request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/runproject", methods=['POST'])
def runProject():
    dic = runProjectService(request)
    return json.dumps(dic, ensure_ascii=False)

@app.route("/getallusers", methods=['GET'])
def getAllUsers():
    dic = queryAllUserService(request=request)
    return json.dumps(dic, ensure_ascii=False)

@app.route("/getprojects",methods=['GET'])
def getProjects():
    dic = queryProjects(request=request)
    return json.dumps(dic, ensure_ascii=False)

@app.route("/getprojectstatus",methods=['GET'])
def getProjectStatus():
    dic = getProjectExecuationStatus(request=request)
    return json.dumps(dic, ensure_ascii=False)

if __name__ == "__main__":
    app.run("0.0.0.0", port=12356, debug=True)
