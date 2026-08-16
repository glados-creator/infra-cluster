package main

deny contains msg if {
    service := input[_].contents
    service.kind == "Service"

    sel := service.spec.selector

    depItem := input[_]
    deployment := depItem.contents
    deployment.kind == "Deployment"
    podLabels := deployment.spec.template.metadata.labels
    every k, v in sel { podLabels[k] == v }

    servicePort := service.spec.ports[_]
    targetPort := servicePort.targetPort

    allContainers := getAllContainers(deployment)

    not anyContainerPortMatches(targetPort, allContainers)

    msg = sprintf("Service %s/%s port %v targetPort %v has no matching containerPort in Deployment %s/%s",
                  [service.metadata.namespace, service.metadata.name, servicePort.port, targetPort, deployment.metadata.namespace, deployment.metadata.name])
}

# Helper: returns a flattened list of all containers (main + init)
getAllContainers(deployment) = all if {
    containers := deployment.spec.template.spec.containers
    init := object.get(deployment.spec.template.spec, "initContainers", [])
    all := array.concat(containers, init)
}

anyContainerPortMatches(targetPort, allContainers) if {
    some i, j
    container := allContainers[i]
    port := container.ports[j]
    port.containerPort == targetPort
}

anyContainerPortMatches(targetPort, allContainers) if {
    some i, j
    container := allContainers[i]
    port := container.ports[j]
    port.name == targetPort
}