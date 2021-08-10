import json

import os

from flask import Flask, jsonify, request
from flask_cors import CORS

from service.project_service import createProjectService, getProjectExecuationStatus, queryProjects, runProjectService
from service.user_service import (createUserService, loginService,
                                  queryAllUserService, setUserService)

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


@app.route("/getprojects", methods=['GET'])
def getProjects():
    dic = queryProjects(request=request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/getprojectstatus", methods=['GET'])
def getProjectStatus():
    dic = getProjectExecuationStatus(request=request)
    return json.dumps(dic, ensure_ascii=False)


@app.route("/test", methods=['post'])
def testPost():
    try:
        if request.values.get("start") == str(2) and request.values.get(
                "length") == str(10):
            _json = json.loads(request.data)
            if _json.get("name", None) == "张三":
                return json.dumps({
                    "message": "ok",
                    "code": 200
                },
                                  ensure_ascii=False)
            else:
                return json.dumps({
                    "message": "json error",
                    "code": 201
                },
                                  ensure_ascii=False)
        else:
            return json.dumps({
                "message": "param error",
                "code": 202
            },
                              ensure_ascii=False)
    except:
        return json.dumps({
            "message": "error",
            "code": 203
        },
                          ensure_ascii=False)


if __name__ == "__main__":
    app.run("0.0.0.0", port=12356, debug=False)
