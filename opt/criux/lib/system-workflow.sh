# system-workflow.sh

WORKFLOW_cluster_DESCRIPTION="check the UNIX system"
set -A WORKFLOWS ${WORKFLOWS[@]} "system"

function WORKFLOW_system {

    SourceStage "init"

    SourceStage "system"

    # in case we SourceStage "system" from "cluster" workflow we may not source cleanup stage
    # as this will be done by the cluster stage definition
    [[ "$WORKFLOW" = "system" ]] && SourceStage "cleanup"
}
