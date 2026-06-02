#!/bin/bash
set -e

# Disable proxy interference for local connections
export no_proxy="localhost,127.0.0.1,0.0.0.0,${MASTER_IP:-127.0.0.1}"
export NO_PROXY="localhost,127.0.0.1,0.0.0.0,${MASTER_IP:-127.0.0.1}"

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Priority: 1. Environment variable, 2. Standard image path, 3. Local repo path
if [ -d "/workspace/UCAgent/summit_examples" ]; then
    DEFAULT_SUMMIT_ROOT="/workspace/UCAgent/summit_examples"
else
    DEFAULT_SUMMIT_ROOT="$SCRIPT_DIR/examples"
fi
SUMMIT_ROOT="${SUMMIT_ROOT:-$DEFAULT_SUMMIT_ROOT}"
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
rm -f "$SUMMIT_ROOT/.ucagent/master_db/agents.json"
rm -f "$SUMMIT_ROOT/.ucagent/master_db/workspaces.json"
rm -f "$SUMMIT_ROOT/.ucagent/master_db/tasks.json"
rm -rf "$SUMMIT_ROOT/.ucagent/master_db/task_logs/"*
echo " -> Permissions updated and stale agent records cleared."

echo "Step 1: Starting background agents for demo tasks..."
TASK_SPECS=(
    "e203_exu_alu:e203_exu_alu:8765:8000:8818:861ed625ed6d4a9684772915ab49a263"
    "iCache_WayLookup:WayLookup:8766:8001:8819:861ed625ed6d4a9684772915ab49a264"
)

for spec in "${TASK_SPECS[@]}"; do
    IFS=":" read -r TASK_DIR_NAME DUT_NAME CMD_PORT WEB_PORT TERM_PORT AGENT_ID <<<"$spec"
    task_dir="$SUMMIT_ROOT/$TASK_DIR_NAME"

    if [ ! -d "$task_dir/workspace" ]; then
        echo " -> Skipping $TASK_DIR_NAME ($DUT_NAME): workspace not found"
        continue
    fi

    LOG_FILE="$LOG_DIR/agent_${DUT_NAME}.log"

    echo " -> Sanitizing agent state to prevent git hash resolution errors..."
    python3 -c "import json; p='$task_dir/workspace/.ucagent/ucagent_info.json'; u=json.load(open(p)); [s.get('meta_data', {}).pop('commit', None) for s in u.get('stages_info', {}).values()]; u['is_agent_exit']=True; u['all_completed']=True; u['stage_index']=len(u.get('stages_info', {})); json.dump(u, open(p, 'w'), indent=4)" || true

    echo " -> Launching Agent for $DUT_NAME from $TASK_DIR_NAME on port $CMD_PORT... (Log: $LOG_FILE)"
    # Use --client-id and re-enable --human
    (tail -f /dev/null | ucagent "$task_dir/workspace" "$DUT_NAME" --human --master "$MASTER_ADDR" --export-cmd-api "0.0.0.0:$CMD_PORT" --web-terminal "0.0.0.0:$TERM_PORT" --client-id "$AGENT_ID" >"$LOG_FILE" 2>&1) &
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

# Continuous output of master logs, filtered to skip initialization noise
tail -n +1 -f "$MASTER_LOG" | grep --line-buffered -A 999999 "Master API server started:" &
TAIL_PID=$!

# Cleanup on exit
trap "echo 'Stopping services...'; kill $MASTER_PID $TAIL_PID 2>/dev/null; exit" SIGINT SIGTERM

wait $MASTER_PID
