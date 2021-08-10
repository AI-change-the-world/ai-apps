from typing import Any, TypeVar
import random
from faker import Faker

fake = Faker("zh_CN")

NullableDict = TypeVar("NullableDict", dict, None)

from LAC import LAC
# 装载分词模型
lac = LAC(mode='lac')


class FakeObj:
    ...


__reserved_loc_types__ = {
    "n": "名词",
    "nz": "专有名词",
    "PER": "人名",
    "LOC": "地名",
    "ORG": "机构名",
    "TIME": "时间",
}

__reserved_http_method__ = [
    "GET",
    "POST",
    "DELETE",
    "PUT"
]

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



class FakeParam:
    def __init__(self,
                 val: Any,
                 ptype: str = "",
                 pmin: float = 0,
                 pmax: float = 0,
                 pmaxLength: int = 0,
                 prange: list = []) -> None:
        self.val = val
        self.ptype = ptype
        self.pmin = pmin
        self.pmax = pmax
        self.pmaxLength = pmaxLength if ptype != "STRING" else len(val) 
        self.prange = prange
        self.__setRange()

    def __setRange(self):
        if self.ptype == "NUMBER":
            self.prange = [
                self.val * 1.0, self.val * -1.0, self.val * 10, self.val * 0.1,
                int(self.val),
                str(self.val),
                str(self.val) + "test"
            ]

    def makeFake(self):
        if self.ptype == "NUMBER":
            return random.choice(self.prange)
        else:
            if self.ptype == "PER":
                return fake.name()
            elif self.ptype == "ORG":
                return fake.company()
            elif self.ptype == "TIME":
                return fake.date()
            elif self.ptype == "LOC":
                return fake.province() + fake.city() + fake.street_address()
            else:
                return randomStr(random.randint(1, self.pmaxLength))

    def __str__(self) -> str:
        return self.ptype
