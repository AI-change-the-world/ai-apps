""" a script to convert json-like string to a python object
"""

import json
import traceback
import copy

from utils.atester.utils import FakeObj, FakeParam, NullableDict, lac



def lac2Type(v):
    if type(v) is list:
        _list = []
        for i in v:
            _list.append(lac2Type(i))
        return _list
    elif type(v) is dict:
        _dic = copy.deepcopy(v)
        for _k, _v in v.items():
            _dic.update({_k: lac2Type(_v)})
        return _dic
    else:
        if str(v).isdigit():
            return FakeParam(val=float(v), ptype="NUMBER", pmax=10000, pmin=-10000)
        else:
            lac_result = lac.run(v)
            if "PER" in lac_result[1]:
                return FakeParam(val=v,
                                 ptype="NUMBER"
                                 "PER",
                                 pmaxLength=2 * len(v))
            elif "LOC" in lac_result[1]:
                return FakeParam(val=v,
                                 ptype="NUMBER"
                                 "LOC",
                                 pmaxLength=2 * len(v))
            elif "TIME" in lac_result[1]:
                return FakeParam(val=v, ptype="NUMBER" "TIME", pmaxLength=50)
            elif "ORG" in lac_result[1]:
                return FakeParam(val=v, ptype="NUMBER" "ORG", pmaxLength=200)
            else:
                return FakeParam(val=v,
                                 ptype="NUMBER"
                                 "STRING",
                                 pmaxLength=len(str(v)*2))


def fakeParams(v: FakeParam):
    if type(v) is list:
        _list = []
        for i in v:
            _list.append(fakeParams(i))
        return _list
    elif type(v) is dict:
        _dic = copy.deepcopy(v)
        for _k, _v in v.items():
            _dic.update({_k: fakeParams(_v)})
        return _dic
    else:
        return v.makeFake()


class Parser:
    def __init__(self, jsonStr: str, withType=True) -> None:
        self.jsonStr = jsonStr
        self.dic = self._jsonToDict(self.jsonStr)
        self.obj = FakeObj()
        self.withType = withType
        self.paramsType = {}

        print(self.dic)

    def _jsonToDict(self, val: str) -> NullableDict:
        dic = None
        if type(val) is dict:
            dic = val
        try:
            dic = json.loads(val)
        except:
            # print(val)
            pass
            # traceback.print_exc()

        return dic

    def parse(self):
        self._dicToObj(self.dic)

        if self.withType:
            self._dicToTypes(self.dic)
        return self.obj

    def _dicToObj(self, dic: NullableDict):
        if dic is None:
            return

        for k, v in dic.items():
            if type(v) is not list:
                if self._jsonToDict(v) is None:
                    setattr(self.obj, k, v)
                else:
                    setattr(self.obj, k, self._dicToObj(v))
            else:
                _obj = []
                for i in v:
                    if type(i) is not NullableDict:
                        _obj.append(i)
                    else:
                        _obj.append(self._dicToObj(i))
                setattr(self.obj, k, _obj)

    def _dicToTypes(self, dic: NullableDict):
        for k, v in dic.items():
            self.paramsType.update({k: lac2Type(v)})

    def makefakes(self, times: int = 1) -> list:
        res = []
        for _ in range(0, times):
            _resdict = copy.deepcopy(self.paramsType)
            for k, v in _resdict.items():
                _resdict.update({k: fakeParams(v)})
            res.append(_resdict)

        return res
