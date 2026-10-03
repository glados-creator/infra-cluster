import model as m

app = m.App(
    name="glance",
    containers=[
        m.Container(
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
    ],
)