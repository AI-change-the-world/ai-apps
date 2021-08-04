import json
import time
from flask.wrappers import Request
from utils import (__code_dict__, __invalid_user__, __ok__, __param_error__,
                   __server_error__, __multi_user__, __only_one_root__)
from utils.model import User
import traceback


def loginService(request: Request) -> dict:
    """{"username":...,"password":...}
    """
    ip = request.remote_addr
    current_time = time.strftime("%Y/%m/%d %H:%M:%S")
    dic = {}
    try:
        data = json.loads(request.data)
        username = data.get("username", None)
        password = data.get("password", None)
        if username is None or password is None:
            dic = {
                "code": __param_error__,
                "message": __code_dict__.get(__param_error__, ""),
                "data": None
            }
        user = User.get(User.user_name == username, User.password == password)
        # user = User.select().where(User.user_name == username, User.password == password)
        # print(type(user))
        dic = {
            "code": __ok__,
            "message": __code_dict__.get(__ok__, ""),
            "data": {
                "is_logged": user.is_login,
                "is_root": user.is_root
            }
        }
        user.last_login_ip = ip
        user.last_login_time = current_time
        user.save()
    except User.DoesNotExist:
        traceback.print_exc()
        dic = {
            "code": __invalid_user__,
            "message": __code_dict__.get(__invalid_user__, ""),
            "data": None
        }

    except:
        traceback.print_exc()
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic


def createUserService(request: Request) -> dict:
    """{"username":...,"password":...,"is_login":0/1,"is_root":0/10}
    """
    dic = {}
    try:
        data = json.loads(request.data)
        username = data.get("username", None)
        password = data.get("password", None)
        is_login = data.get("is_login", None)
        is_root = data.get("is_root", None)

        user = User.select().where(User.user_name == username)
        # print(len(user))
        if len(user) > 0:
            dic = {
                "code": __multi_user__,
                "message": __code_dict__.get(__multi_user__, ""),
                "data": None
            }
        elif is_root == 1:
            dic = {
                "code": __only_one_root__,
                "message": __code_dict__.get(__only_one_root__, ""),
                "data": None
            }
        else:
            p = User(is_login=1,
                     is_root=0,
                     last_login_ip="0",
                     last_login_time='0',
                     password=password,
                     user_name=username)
            p.save()
            dic = {
                "code": __ok__,
                "message": __code_dict__.get(__ok__, ""),
                "data": None
            }
    except:
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic


def setUserService(request: Request) -> dict:
    dic = {}
    try:
        data = json.loads(request.data)
        username = data.get("username", None)
        is_login = data.get("is_login", None)
        password = data.get("password", None)
        user = User.get(User.user_name == username)
        if is_login is not None:
            user.is_login = is_login
        if password is not None:
            user.password = password
        user.save()
        dic = {
            "code": __ok__,
            "message": __code_dict__.get(__ok__, ""),
            "data": None
        }
    except User.DoesNotExist:
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }
    except:
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic