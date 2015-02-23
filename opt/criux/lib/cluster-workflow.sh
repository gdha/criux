# cluster-workflow.sh

WORKFLOW_cluster_DESCRIPTION="check the cluster configuration"
set -A WORKFLOWS ${WORKFLOWS[@]} "cluster"

function WORKFLOW_cluster {
    # init will initialize CURRENT_STATUS variable
    SourceStage "init"

    proceed_to_next_stage "cluster" && SourceStage "cluster"
    #proceed_to_next_stage "preremove" && SourceStage "preremove"
    #proceed_to_next_stage "preinstall" && SourceStage "preinstall"
    #proceed_to_next_stage "install" && SourceStage "install"
    #proceed_to_next_stage "postinstall" && SourceStage "postinstall"
    #proceed_to_next_stage "postremove" && SourceStage "postremove"
    #proceed_to_next_stage "configure" && SourceStage "configure"
    #proceed_to_next_stage "postexecute" && SourceStage "postexecute"

    SourceStage "cleanup"
}
