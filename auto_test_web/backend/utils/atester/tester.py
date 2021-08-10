import time

class Tester:
    def __init__(self,
                 url,
                 api: str = "",
                 name: str = "",
                 params: str = "",
                 filepath: str = "") -> None:
        self.url = url
        self.api = api
        self.name = name
        self.params = params
        self.filepath = filepath

    def _generateConfig(self):
        pass

    def _generateName(self):
        if self.name == "":
            filename = str(time.time()).replace(".",'') + ".yaml"

        elif not self.name.endswith(".yaml"):
            filename = self.name.replace(".", "") + ".yaml"

        else:
            filename = self.name

        self.name = filename