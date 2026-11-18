import model as m
from public import public
from dmz import dmz
from private import private

pub = m.Namespace("public")
pub.folders = public
d = m.Namespace("dmz")
d.folders = dmz
priv = m.Namespace("private")
priv.folders = private

envs = [
    m.Environement("prod").namespace(pub).namespace(d).namespace(priv),
    m.Namespace("default").folder(
        m.App("glance").pod(m.Pod(
            image="glanceapp/glance:latest",
            ports=[
                m.Port(
                    number=8080
                )
            ],
            mounts=[
                m.Config(
                    name="config",
                    at="/app/config",
                    file="glance.yaml",
                    ro=True,
                )
            ],
            )
        )
    ),
]