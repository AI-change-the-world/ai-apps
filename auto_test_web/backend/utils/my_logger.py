import logging
from logging import INFO, getLogger
import os

from concurrent_log_handler import ConcurrentRotatingFileHandler

current_dir = os.getcwd()
log_file = current_dir + os.sep + "logs" + os.sep + 'log.txt'

logger = getLogger(__name__)
formatter_log = logging.Formatter(
    '%(asctime)s - %(filename)s [line: %(lineno)d] [%(levelname)s] ----- %(message)s'
)
rotateHandler = ConcurrentRotatingFileHandler(log_file, "a", 512 * 1024, 5)
rotateHandler.setFormatter(formatter_log)
logger.addHandler(rotateHandler)
logger.setLevel(INFO)