from typing import Union
from fastapi import FastAPI


def start_application():
    return FastAPI(title="git-action-test", version="1.0")


app = start_application()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
