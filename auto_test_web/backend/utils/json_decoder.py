import json
from typing import List
# from utils.my_logger import logger


class ApiClass:
    def __init__(self,
                 path: str = '',
                 method: str = '',
                 data: dict = {},
                 queryData: dict = {}) -> None:
        self.path = path
        self.method = method
        self.data = data
        self.queryData = queryData


def apiJsonDecoder(s: str) -> List[ApiClass]:
    try:
        res = []
        f = open(s, 'r', encoding="utf-8")
        _j = json.load(f)  #list
        f.close()
        for i in _j:
            # i is a dict
            _list = i["list"]
            for _l in _list:
                method = _l["method"]
                path = _l["path"]
                body_data = _l.get("req_body_other", None)
                req_query = _l.get("req_query", [])  # list
                _d = {}
                if req_query != []:
                    for _r in req_query:
                        _d[_r['name']] = "这里要输入类型"
                _d_body = {}
                if body_data is not None:
                    body_data_dict = json.loads(body_data)
                    # print(body_data_dict)
                    properties = body_data_dict.get("properties", None)
                    if properties is not None:
                        for k, v in properties.items():
                            _type = v.get("type", "Unknown")
                            _d_body[k] = _type

                ac = ApiClass()
                ac.method = method
                ac.path = path
                ac.queryData = _d
                ac.data = _d_body
                res.append(ac)
                print(json.dumps(ac.__dict__, ensure_ascii=False))
        return res

    except Exception as e:
        # logger.error(str(e))
        print(e)
        return []


if __name__ == "__main__":
    apiJsonDecoder(
        "D:\\github_repo\\ai-apps\\auto_test_web\\backend\\tests\\api.json")
