from utils.atester.utils import __reserved_http_method__
from typing import Any, List
# from atester.utils.json_to_python import Parser
from utils.atester.utils.json_to_python import Parser
import time
import random
import json as _json
# from .logger import logger
# import traceback


def generateName(name: str):
    if name == "":
        name = str(time.time()).replace(".", '')
    return name


class HttprunnerRequest:
    def __init__(self, url, method, json: dict = None, params=None) -> None:
        self.url = url
        self.method = method
        self.json = json
        self.params = params

    def bound(self):
        return {
            "url": self.url,
            "method": self.method,
            "json": self.json,
            "params": self.params
        }

    def __eq__(self, o: object) -> bool:
        return self.json == o.json and self.method == o.method and self.params == o.params


def makeHttprunnerRequests(
        times: int = 1,
        json: Any = None,
        params: Any = None,
        url: str = "",
        method: str = "GET",
        switchMethod: bool = False) -> List[HttprunnerRequest]:
    # print("==============================")
    # print(params)
    # print("==============================")
    res = []
    res.append(
        HttprunnerRequest(url, method,
                          _json.loads(json) if type(json) is str else json,
                          params))
    # p = Parser(json)
    # _ = p.parse()
    # o = p.makefakes(times)
    # # print(o)
    # for i in o:
    #     _m = method
    #     if switchMethod:
    #         _m = random.choice(__reserved_http_method__)
    #     # print("==============================")
    #     # print(params)
    #     # print("==============================")
    #     hpr = HttprunnerRequest(url, _m, i, params)
    #     res.append(hpr)

    return res


class HttpRunnerConfig:
    def __init__(self, name: str = "", variables: dict = {}) -> None:
        self.name = generateName(name)
        self.variables = variables

    def setVariables(self, key: str, val):
        dic = {key: val}
        self.variables.update(dic)

    def bound(self):
        return {"config": {"name": self.name, "variables": self.variables}}


class HttpValidate:
    def __init__(self) -> None:
        self.validates = []

    def addValidate(self, k, v, comparator: str = "eq"):
        _val = [k, v]
        # self.validates.append({[{"eq": '{}, {}'.format(k, v)}]})
        self.validates.append({comparator: _val})

    def bound(self):
        return self.validates


class HttprunnerTeststep:
    def __init__(self,
                 name: str = "",
                 request: dict = {},
                 validate: list = []) -> None:
        self.name = generateName(name=name)
        self.request = request
        self.validate = validate

    def setRequest(self, req: dict):
        self.request = req

    def setValidate(self, val: dict):
        self.validate = val

    def bound(self):
        return {
            "name": self.name,
            "request": self.request,
            "validate": self.validate
        }


class HttpRunnerClass:
    def __init__(self, config=None, teststeps: list = []) -> None:
        self.config = config
        self.teststeps = teststeps

    def bound(self):
        dic = {}
        dic.update(self.config)
        dic.update({"teststeps": self.teststeps})

        return dic
