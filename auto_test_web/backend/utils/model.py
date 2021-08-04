from peewee import *

database = MySQLDatabase('testdb', **{'charset': 'utf8', 'sql_mode': 'PIPES_AS_CONCAT', 'use_unicode': True, 'host': '127.0.0.1', 'port': 3306, 'user': 'root', 'password': '123456'})

class UnknownField(object):
    def __init__(self, *_, **__): pass

class BaseModel(Model):
    class Meta:
        database = database

class ActionLog(BaseModel):
    action_log_id = AutoField()
    action_time = DateTimeField()
    end_time = DateTimeField()
    fail_times = IntegerField(index=True)
    start_time = DateTimeField()
    success_times = IntegerField(index=True)
    test_times = IntegerField(index=True)
    total_api_times = IntegerField(index=True)
    user_id = IntegerField(index=True)

    class Meta:
        table_name = 'action_log'

class ExecLog(BaseModel):
    action_time = CharField(null=True)
    admin_id = IntegerField(null=True)
    end_time = CharField(null=True)
    fail_times = IntegerField(null=True)
    projrct_id = IntegerField(null=True)
    result_path = CharField(null=True)
    start_time = CharField(null=True)
    success_times = IntegerField(null=True)
    test_times = IntegerField(null=True)
    total_api_times = IntegerField(null=True)

    class Meta:
        table_name = 'exec_log'
        primary_key = False

class Project(BaseModel):
    create_time = DateField()
    file_path = CharField()
    project_id = AutoField()
    user_id = IntegerField(index=True)

    class Meta:
        table_name = 'project'

class User(BaseModel):
    is_login = IntegerField(index=True)
    is_root = IntegerField(index=True)
    last_login_ip = CharField()
    last_login_time = CharField()
    password = CharField()
    user_id = AutoField()
    user_name = CharField(unique=True)

    class Meta:
        table_name = 'user'