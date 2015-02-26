# cluster-workflow.sh

WORKFLOW_cluster_DESCRIPTION="check the cluster configuration"
set -A WORKFLOWS ${WORKFLOWS[@]} "cluster"

function WORKFLOW_cluster {
    # init will initialize CURRENT_STATUS variable
    SourceStage "init"

    # Stage 'cluster' (directory) is generic where we will find out the type of the cluster
    SourceStage "cluster"

    # according the type we will source another stage
    # currenly we only have serviceguard, but veritascluster, hacmp, etc.. are candidates
    [[ "$SERVICEGUARD_CLUSTER" =~ ^[yY1] ]] && SourceStage "serviceguard"
    [[ "$VERITAS_CLUSTER" =~ ^[yY1] ]] && SourceStage "vcs"
    [[ "$POWERHA_CLUSTER" =~ ^[yY1] ]] && SourceStage "powerha"

    SourceStage "cleanup"
}
