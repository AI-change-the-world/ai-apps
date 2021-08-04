import json
import time
import traceback

from flask.wrappers import Request
from utils import __code_dict__, __server_error__
from utils.model import Project


def createProjectService(request: Request) -> dict:
    dic = dict()
    current_time = str(time.time()).replace(".", "")
    try:
        data = json.loads(request.data)
    except:
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic