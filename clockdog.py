from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time
import os
import subprocess
import threading


class WriteChangeHandler(FileSystemEventHandler):
    def __init__(self):
        self._lock = threading.Lock()

    def on_modified(self, event):
        if event.is_directory:
            return
        if '.git' in event.src_path.split(os.sep):
            return

        if not self._lock.acquire(blocking=False):
            return
        try:
            subprocess.run([path + "/test_runner.sh"], shell=True)
        finally:
            threading.Timer(1.0, self._lock.release).start()


if __name__ == "__main__":
    path = os.getcwd()  # Current directory
    event_handler = WriteChangeHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=True)
    observer.start()
    print(f"Watching for changes in {path} and all subdirectories...")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
