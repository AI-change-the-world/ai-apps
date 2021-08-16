__ok__ = 10
# 一般错误
__server_error__ = 11
__param_error__ = 12
# 登陆
__invalid_user_name__ = 21
__password_error__ = 22
__invalid_user__ = 23
__has_logged__ = 24
# 新建用户
__multi_user__ = 31
__only_one_root__ = 32
# 新建项目
__multi_project_name__ = 41
__invalid_json__ = 42
# 运行项目
__invalid_project__ = 43
__project_done__ = 44
__project_create_ok__ = 40
__invalid_project_ststus__ = 45
__unnessary_project__ = 46
__invalid_project_url__ = 47

__code_dict__ = {
    __ok__: "正常",
    __server_error__: "服务器异常",
    __param_error__: "参数异常",
    # 登陆
    __invalid_user_name__: "用户名不存在",
    __password_error__: "密码错误",
    __invalid_user__: "用户信息错误",
    __has_logged__: "当前用户已禁用",
    # 新建用户
    __multi_user__: "用户名重复",
    __only_one_root__: "只能有一位巫妖王",
    # 新建项目
    __multi_project_name__: "项目名重复",
    __invalid_json__: "json 不正确",
    __invalid_project__: "项目不存在",
    __project_done__: "项目已完成",
    __project_create_ok__: "已创建任务，正在后台执行",
    __invalid_project_ststus__: "项目运行状态不明",
    __unnessary_project__: "不可重复创建项目",
    __invalid_project_url__: "project的url为空"
}

__reserved_type__ = [
    "INTEGER",
    "PER",
    "ORG",
    "TIME",
    "LOC",
    "STRING",
]