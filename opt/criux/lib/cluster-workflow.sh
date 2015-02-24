# cluster-workflow.sh

WORKFLOW_cluster_DESCRIPTION="check the cluster configuration"
set -A WORKFLOWS ${WORKFLOWS[@]} "cluster"

function WORKFLOW_cluster {
    # init will initialize CURRENT_STATUS variable
    SourceStage "init"

    SourceStage "cluster"

    SourceStage "cleanup"
}
