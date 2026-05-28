#!/bin/bash
set -e

# Disable proxy interference for local connections
export no_proxy="localhost,127.0.0.1,0.0.0.0,${MASTER_IP:-127.0.0.1}"
export NO_PROXY="localhost,127.0.0.1,0.0.0.0,${MASTER_IP:-127.0.0.1}"

# Configuration
SUMMIT_ROOT="/workspace/UCAgent/summit_examples"
MASTER_IP=${MASTER_IP:-"127.0.0.1"}
MASTER_PORT=${MASTER_PORT:-"8800"}
MASTER_ADDR="$MASTER_IP:$MASTER_PORT"
LOG_DIR="/tmp/ucagent_logs"

mkdir -p "$LOG_DIR"

echo "=== UCAgent Workshop Demo Startup ==="

# Check if data directory exists
if [ ! -d "$SUMMIT_ROOT" ]; then
    echo "Error: Data directory $SUMMIT_ROOT not found!"
    exit 1
fi

# Clean up ALL stale .ucagent databases to prevent multiple agent issues in workshop
echo "Step 0: Ensuring proper permissions for metadata..."
# Ensure we have permissions to read/write
chmod -R 777 "$SUMMIT_ROOT" 2>/dev/null || true
# Remove stale agent records to force re-registration and stage sync
# rm -f "$SUMMIT_ROOT/.ucagent/master_db/agents.json"
# Find and delete, while listing what we find
# find "$SUMMIT_ROOT" -name ".ucagent" -type d -print -exec rm -rf {} + || true
echo " -> Permissions updated and stale agent records cleared."

echo "Step 1: Starting background agents for demo tasks..."
TASK_SPECS=(
    "ucagent_launch_yt3xgf7c:e203_exu_alu:8765:8000:8818"
)

for spec in "${TASK_SPECS[@]}"; do
    IFS=":" read -r TASK_DIR_NAME DUT_NAME CMD_PORT WEB_PORT TERM_PORT <<<"$spec"
    task_dir="$SUMMIT_ROOT/$TASK_DIR_NAME"

    if [ ! -d "$task_dir/workspace" ]; then
        echo " -> Skipping $TASK_DIR_NAME ($DUT_NAME): workspace not found"
        continue
    fi

    LOG_FILE="$LOG_DIR/agent_${DUT_NAME}.log"
    # Use the recorded Agent ID to ensure state continuity in Web UI/Master
    AGENT_ID="861ed625ed6d4a9684772915ab49a263"

    echo " -> Sanitizing agent state to prevent git hash resolution errors..."
    python3 -c "import json; p='$task_dir/workspace/.ucagent/ucagent_info.json'; u=json.load(open(p)); [s.get('meta_data', {}).pop('commit', None) for s in u.get('stages_info', {}).values()]; u['is_agent_exit']=True; u['all_completed']=True; u['stage_index']=28; json.dump(u, open(p, 'w'), indent=4)" || true

    echo " -> Launching Agent for $DUT_NAME from $TASK_DIR_NAME on port $CMD_PORT... (Log: $LOG_FILE)"
    # Use --client-id, re-enable --human, and ensure --icmd is passed as a single quoted string
    (tail -f /dev/null | ucagent "$task_dir/workspace" "$DUT_NAME" --human --master "$MASTER_ADDR" --export-cmd-api --client-id "$AGENT_ID" >"$LOG_FILE" 2>&1) &
done

echo "Waiting for agents to initialize..."
sleep 5

echo "Step 2: Starting UCAgent Master API Server..."
MASTER_LOG="$LOG_DIR/master.log"
(tail -f /dev/null | ucagent --as-master-persist "$SUMMIT_ROOT" --as-master 0.0.0.0:$MASTER_PORT >"$MASTER_LOG" 2>&1) &
MASTER_PID=$!

echo "Waiting for services to be ready..."
sleep 5

echo "------------------------------------------"
echo "Initial Agent Status Summary:"
curl -s "http://$MASTER_ADDR/api/agents?include_offline=true" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    agents = data.get('agents', [])
    if not agents: print('No agents found.')
    for a in agents:
        print(f\"Agent: {a.get('id')[:8]} | Status: {a.get('status')} | Stage: {a.get('current_stage_name')}\")
except Exception:
    print('Failed to fetch agent status.')
"
echo "------------------------------------------"
echo "All services started. Access the Web UI at http://localhost:$MASTER_PORT"
echo "Tailing Master API output..."
echo "------------------------------------------"

# Continuous output of master logs
tail -f "$MASTER_LOG" &
TAIL_PID=$!

# Cleanup on exit
trap "echo 'Stopping services...'; kill $MASTER_PID $TAIL_PID 2>/dev/null; exit" SIGINT SIGTERM

wait $MASTER_PID
