# cluster-workflow.sh

WORKFLOW_cluster_DESCRIPTION="check the cluster configuration"
set -A WORKFLOWS ${WORKFLOWS[@]} "cluster"

function WORKFLOW_cluster {

    # once the 'system' workflow is ready we can remove the init and add 'system' instead
    SourceStage "init"

    # Stage 'system' workflow to inspect the local node
    SourceStage "system"
    
    # Stage 'cluster' (directory) is generic where we will find out the type of the cluster
    SourceStage "cluster"

    # according the type we will source another sub-stage
    # currenly we only have serviceguard, but veritascluster, hacmp, etc.. are candidates
    case "$SERVICEGUARD_CLUSTER" in
        y|Y|1) SourceStage "serviceguard" ;;
    esac

    case "$VERITAS_CLUSTER" in
        y|Y|1) SourceStage "vcs" ;;
    esac

    case "$POWERHA_CLUSTER" in
       y|Y|1) SourceStage "powerha" ;;
    esac

    SourceStage "cleanup"
}
