from fastapi import FastAPI


def start_application():
    return FastAPI(title="git-action-test", version="1.0")


app = start_application()


@app.get("/")
def root_v1():
    return {"Hello": "World"}


@app.get("/v2")
def root_v2():
    return {"version": "update"}
