package main

# Deny if a Deployment does not specify a serviceAccountName (or it's empty)
deny contains msg if {
    dep := input[_].contents
    dep.kind == "Deployment"

    # Default to empty string if field is missing or null
    saName := object.get(dep.spec.template.spec, "serviceAccountName", "")

    # If it's empty or missing, fail
    saName == ""

    msg = sprintf("Deployment %s/%s does not specify a serviceAccountName",
                  [dep.metadata.namespace, dep.metadata.name])
}

# Deny if a Deployment references a ServiceAccount that does not exist
deny contains msg if {
    dep := input[_].contents
    dep.kind == "Deployment"

    saName := object.get(dep.spec.template.spec, "serviceAccountName", "")
    saName != ""  # only check if it's actually set

    # Check if a ServiceAccount with same name and namespace exists
    not saExists(saName, dep.metadata.namespace)

    msg = sprintf("ServiceAccount %s/%s referenced by Deployment %s/%s does not exist",
                  [dep.metadata.namespace, saName, dep.metadata.namespace, dep.metadata.name])
}

# Helper: returns true if a ServiceAccount exists in the given namespace
saExists(name, namespace) if {
    some i
    item := input[i]
    sa := item.contents
    sa.kind == "ServiceAccount"
    sa.metadata.name == name
    sa.metadata.namespace == namespace
}