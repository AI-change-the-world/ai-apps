import json
import os
import random
from utils.httprunner_wrap import wrapper
import yaml
import random
from faker import Faker

fake = Faker("zh_CN")

from utils import __reserved_type__
from utils.atester.utils.httprunner_class import (
    HttpRunnerClass, HttpRunnerConfig, HttprunnerRequest, HttprunnerTeststep,
    HttpValidate, makeHttprunnerRequests)
from utils.model import ExecLog
from utils.my_logger import logger
import traceback

basepath = os.getcwd()

base_str = '一个冬天的黄昏，我和我的朋友歇洛克·福尔摩斯’‘、对坐在壁炉两侧，福尔摩斯说道：“华生，我这里有？？。，”：“几个文件，我确实认为很“：；值得你一读。|、这些文件和*（）‘格洛里亚斯科特’号三桅帆船奇案有关￥%……&系。治安官老特雷！@#佛就是因读了这些文件惊吓而死的。” 【】'


def randomStr(length: int = 1):
    random_str = ""
    l_max = len(base_str) - 1
    # print(len(base_str) - 1)
    for _ in range(length):
        p = random.randint(0, l_max)
        # print(p)
        # print(base_str[p])
        random_str += str(base_str[p])
    return random_str


def execProject(path: str, url: str, projectId: int, userId: int) -> None:
    print("进入方法...")
    try:
        _ = ExecLog.get(ExecLog.projrct_id == projectId,
                            ExecLog.admin_id == userId)
        if not os.path.exists(path):
            ExecLog.update(result_path="ERROR").where(ExecLog.projrct_id == projectId,
                            ExecLog.admin_id == userId).execute()
            return

        resultDir = basepath + os.sep + "results" + os.sep + str(projectId)

        htmlPath = "--html=" + resultDir + os.sep + "result.html"

        if not os.path.exists(resultDir):
            print("文件夹不存在，正在创建...")
            os.mkdir(resultDir)

        with open(path, 'r', encoding='utf-8') as f:
            load_dict = json.load(f)
            # print(load_dict)
            boundries = load_dict.get("boundries", None)
            json_ = load_dict.get("json", None)
            params = load_dict.get("params", None)
            method = load_dict.get("method", None)

            if boundries is None or json_ is None or params is None or method is None:
                # exec_.save()
                ExecLog.update(result_path="lack of params").where(ExecLog.projrct_id == projectId,
                            ExecLog.admin_id == userId).execute()
                return
            # exec_.save()
            for k, v in json_.items():
                if v in __reserved_type__:
                    json_[k] = getParams(v)
                    # print(__reserved_type__.get(k, None))
            for k, v in params.items():
                if v in __reserved_type__:
                    params[k] = getParams(v)

            print("获取参数完成...")

            hc = HttpRunnerConfig()
            hcDic = hc.bound()

            print("hc完成...")

            hrs = makeHttprunnerRequests(times=10,
                                         json=json_,
                                         params=params,
                                         method=method,
                                         url=url)
            print("hrs完成...")
            hvs = []
            hv1 = HttpValidate()
            for k, v in boundries.items():
                pvs = k.split("___")
                hv1.addValidate(pvs[0], v, comparator=pvs[1])
            hv1dic = hv1.bound()
            hvs.append(hv1dic)

            print("hvs完成...")

            for i in range(1, len(hrs)):
                if hrs[i] == hrs[0]:
                    hvs.append(hv1dic)
                else:
                    _hv = HttpValidate()
                    for k, v in boundries.items():
                        pvs = k.split("___")
                        _hv.addValidate(pvs[0], v, comparator="ne")
                    hvs.append(_hv.bound())

            print("拓展完成...")

            testSteps = []

            hrc1 = HttpRunnerClass()
            hrc1.config = hcDic
            _p = []
            for i in range(0, len(hrs)):
                p = resultDir + os.sep + "test_{}.yaml".format(i)
                ht1 = HttprunnerTeststep()
                ht1.setRequest(hrs[i].bound())
                ht1.setValidate(hvs[i])
                hrc1.teststeps = [ht1.bound()]
                d = hrc1.bound()
                fp = open(
                    p,
                    'w',
                    encoding='utf-8',
                )
                fp.write(yaml.dump(d, allow_unicode=True))
                fp.close()
                _p.append(p)
            print("文件生成完成...")

            wrapper(_p, htmlPath)

    except ExecLog.DoesNotExist:
        # traceback.print_exc()
        logger.fatal("query not found")
    except Exception as e:
        # exec2 = ExecLog.get(ExecLog.projrct_id == projectId,
        #                     ExecLog.admin_id == userId)
        traceback.print_exc()
        logger.fatal(str(e))
        ExecLog.update(result_path="服务器错误，请看log日志").where(ExecLog.projrct_id == projectId,
                            ExecLog.admin_id == userId).execute()
        # exec2.result_path = "服务器错误，请看log日志"
        # exec2.save()


def getParams(v):
    if v == "INTEGER":
        return random.randint(-1000, 1000)
    elif v == "PER":
        return fake.name()
    elif v == "ORG":
        return fake.company()
    elif v == "TIME":
        return fake.date()
    elif v == "LOC":
        return fake.province() + fake.city() + fake.street_address()
    elif v == "STRING":
        return randomStr(random.randint(1, 255))
    else:
        return "."
