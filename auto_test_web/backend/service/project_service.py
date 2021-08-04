import json
import os
import time
import traceback

from flask.wrappers import Request
from playhouse.shortcuts import model_to_dict
from utils import (__code_dict__, __invalid_json__, __invalid_user__, __ok__,
                   __param_error__, __server_error__, __invalid_project__,
                   __project_done__, __project_create_ok__)
from utils.model import Project, User, ExecLog

basepath = os.getcwd()


def createProjectService(request: Request) -> dict:
    dic = dict()
    fileName = str(time.time()).replace(".", "")
    current_time = time.strftime("%Y/%m/%d %H:%M:%S")
    try:
        data = json.loads(request.data)
        _uploadType = data.get("upload_type", 0)
        if _uploadType == 0:
            _json = data.get("json", None)
        else:
            f = request.files['json']
        user_id = data.get("user_id", None)

        if _json is None and f is None:
            return {
                "code": __invalid_json__,
                "message": __code_dict__.get(__invalid_json__, ""),
                "data": None
            }
        upload_path = os.path.join(basepath, 'uploads', fileName + ".json")

        user = User.select().where(User.user_id == user_id)
        if len(user) < 1:

            return {
                "code": __invalid_user__,
                "message": __code_dict__.get(__invalid_user__, ""),
                "data": None
            }

        p = Project(create_time=current_time,
                    file_path=upload_path,
                    user_id=user_id)
        p.save()
        dic = {
            "code": __ok__,
            "message": __code_dict__.get(__ok__, ""),
            "data": {
                "project_id": p.project_id
            }
        }
        f = open(upload_path, "w", encoding='utf-8')
        json.dump(_json, f, ensure_ascii=False)
        f.close()

    except:
        traceback.print_exc()
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic


def runProjectService(request: Request) -> dict:
    """user_id,project_id
    """
    dic = dict()
    current_time = time.strftime("%Y/%m/%d %H:%M:%S")
    try:
        data = json.loads(request.data)
        user_id = data.get("user_id", None)
        project_id = data.get("project_id", None)
        if user_id is None or project_id is None:
            return {
                "code": __param_error__,
                "message": __code_dict__.get(__param_error__, ""),
                "data": None
            }
        # e = ExecLog
        p = Project.get(Project.user_id == user_id,
                        Project.project_id == project_id)
        jsonFilePath = p.file_path  # 这里开始新的线程做测试 。。。。。。
        execes = ExecLog.select().where(ExecLog.admin_id == user_id,
                                        ExecLog.projrct_id == project_id)
        if (len(execes)) > 0:
            return {
                "code": __project_done__,
                "message": __code_dict__.get(__project_done__, ""),
                "data": None
            }
        e = ExecLog(
            start_time=current_time,
            admin_id=user_id,
            project_id=project_id,
        )
        e.save()
        dic = {
            "code": __project_create_ok__,
            "message": __code_dict__.get(__project_create_ok__, ""),
            "data": None
        }
    except Project.DoesNotExist:
        dic = {
            "code": __invalid_project__,
            "message": __code_dict__.get(__invalid_project__, ""),
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


def queryProjects(request: Request) -> dict:
    dic = dict()
    try:
        user_id = request.values.get("userid")
        start = request.values.get("start")
        length = request.values.get("length")
        if user_id is None or start is None or length is None:
            return {
                "code": __param_error__,
                "message": __code_dict__.get(__param_error__, ""),
                "data": None
            }

        user = User.get(User.user_id == user_id)
        if user.is_root == 1:
            rets = Project.select().order_by(Project.project_id).paginate(
                int(start), int(length))
        else:
            # print("="*50)
            rets = Project.select().where(Project.user_id == user_id).order_by(
                Project.project_id).paginate(int(start), int(length))
        print(len(rets))
        lst = []
        if len(rets)>0:
            for ret in rets:
                ret.create_time = str(ret.create_time)
                dct = model_to_dict(ret)
                lst.append(dct)
        dic = {
            "code": __ok__,
            "message": __code_dict__.get(__ok__, ""),
            "data": lst
        }

    except User.DoesNotExist:
        dic = {
            "code": __invalid_user__,
            "message": __code_dict__.get(__invalid_user__, ""),
            "data": None
        }

    except:
        dic = {
            "code": __server_error__,
            "message": __code_dict__.get(__server_error__, ""),
            "data": None
        }

    return dic
