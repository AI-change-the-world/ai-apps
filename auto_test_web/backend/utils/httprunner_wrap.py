from httprunner.loader import load_folder_files, load_test_file
from httprunner.make import format_pytest_with_black, make_testcase, make_testsuite
from loguru import logger
from sentry_sdk import capture_message
from httprunner.compat import ensure_cli_args, ensure_testcase_v3_api
import os
import pytest
from httprunner import exceptions

pytest_files_run_set = set()
pytest_files_made_cache_mapping = {}
def __make(tests_path):
    """ make testcase(s) with testcase/testsuite/folder absolute path
        generated pytest file path will be cached in pytest_files_made_cache_mapping

    Args:
        tests_path: should be in absolute path

    """
    logger.info(f"make path: {tests_path}")
    test_files = []
    if os.path.isdir(tests_path):
        files_list = load_folder_files(tests_path)
        test_files.extend(files_list)
    elif os.path.isfile(tests_path):
        test_files.append(tests_path)
    else:
        raise Exception

    for test_file in test_files:
        if test_file.lower().endswith("_test.py"):
            pytest_files_run_set.add(test_file)
            continue

        try:
            test_content = load_test_file(test_file)
        except (exceptions.FileNotFound, exceptions.FileFormatError) as ex:
            logger.warning(f"Invalid test file: {test_file}\n{type(ex).__name__}: {ex}")
            continue

        if not isinstance(test_content, dict):
            logger.warning(
                f"Invalid test file: {test_file}\n"
                f"reason: test content not in dict format."
            )
            continue

        # api in v2 format, convert to v3 testcase
        if "request" in test_content and "name" in test_content:
            test_content = ensure_testcase_v3_api(test_content)

        if "config" not in test_content:
            logger.warning(
                f"Invalid testcase/testsuite file: {test_file}\n"
                f"reason: missing config part."
            )
            continue
        elif not isinstance(test_content["config"], dict):
            logger.warning(
                f"Invalid testcase/testsuite file: {test_file}\n"
                f"reason: config should be dict type, got {test_content['config']}"
            )
            continue

        # ensure path absolute
        test_content.setdefault("config", {})["path"] = test_file

        # testcase
        if "teststeps" in test_content:
            try:
                testcase_pytest_path = make_testcase(test_content)
                pytest_files_run_set.add(testcase_pytest_path)
            except exceptions.TestCaseFormatError as ex:
                logger.warning(
                    f"Invalid testcase file: {test_file}\n{type(ex).__name__}: {ex}"
                )
                continue

        # testsuite
        elif "testcases" in test_content:
            try:
                make_testsuite(test_content)
            except exceptions.TestSuiteFormatError as ex:
                logger.warning(
                    f"Invalid testsuite file: {test_file}\n{type(ex).__name__}: {ex}"
                )
                continue

        # invalid format
        else:
            logger.warning(
                f"Invalid test file: {test_file}\n"
                f"reason: file content is neither testcase nor testsuite"
            )


def main_make(tests_paths: list) -> list:
    if not tests_paths:
        return []

    for tests_path in tests_paths:
        try:
            __make(tests_path)
        except Exception as e:
            print(e)

    # format pytest files
    pytest_files_format_list = pytest_files_made_cache_mapping.keys()
    format_pytest_with_black(*pytest_files_format_list)

    return list(pytest_files_run_set)


def wrapper_test():
    capture_message("start to run")
    args = ["D:\\github_repo\\easy-api-tester\\tests\\test.yaml", '--html=D:\\github_repo\\easy-api-tester\\tests\\test_1_1.html']
    extra_args  = ensure_cli_args(args)

    tests_path_list = []
    extra_args_new = []
    for item in extra_args:
        if not os.path.exists(item):
            # item is not file/folder path
            extra_args_new.append(item)
        else:
            # item is file/folder path
            tests_path_list.append(item)
    
    testcase_path_list = main_make(tests_path_list)
    if "--tb=short" not in extra_args_new:
        extra_args_new.append("--tb=short")
    extra_args_new.extend(testcase_path_list)
    return pytest.main(extra_args_new)

def wrapper(yamls:list,htmlPath):
    capture_message("start to run")
    pytest_files_made_cache_mapping.clear()
    yamls.append(htmlPath)
    extra_args  = ensure_cli_args(yamls)

    tests_path_list = []
    extra_args_new = []
    for item in extra_args:
        if not os.path.exists(item):
            # item is not file/folder path
            extra_args_new.append(item)
        else:
            # item is file/folder path
            tests_path_list.append(item)
    
    testcase_path_list = main_make(tests_path_list)
    if "--tb=short" not in extra_args_new:
        extra_args_new.append("--tb=short")
    extra_args_new.extend(testcase_path_list)
    return pytest.main(extra_args_new)



# if __name__ == "__main__":
#     i = wrapper_test()

#     print("结果是{}".format(i))