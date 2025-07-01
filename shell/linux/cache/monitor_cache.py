import time
import psutil
import argparse
from collections import deque

def get_cached():
    """Return current cached memory in bytes."""
    return psutil.virtual_memory().cached

def snapshot_process_io():
    """Return a dict of {pid: (read_bytes + write_bytes)}."""
    io_snapshot = {}
    for proc in psutil.process_iter(['pid', 'io_counters']):
        try:
            counters = proc.info['io_counters']
            if counters:
                io_snapshot[proc.pid] = counters.read_bytes + counters.write_bytes
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue
    return io_snapshot

def monitor(window, threshold, interval, top_n):
    history = deque()
    print(f"Monitoring cache every {interval}s, window={window}s, threshold={threshold} bytes")
    while True:
        ts = time.time()
        cached = get_cached()
        io_snap = snapshot_process_io()
        
        # Push current snapshot
        history.append((ts, cached, io_snap))
        
        # Pop old snapshots beyond window
        while history and ts - history[0][0] > window:
            history.popleft()
        
        # Compare current cached with oldest in window
        if len(history) > 1:
            oldest_ts, oldest_cached, oldest_io = history[0]
            if cached - oldest_cached > threshold:
                print("\n=== Cache spike detected! ===")
                print(f"Time window: {oldest_ts:.2f} -> {ts:.2f}")
                print(f"Cached increase: {cached - oldest_cached} bytes")
                
                # Compute per-process I/O during window
                deltas = []
                for pid, io_now in io_snap.items():
                    io_old = oldest_io.get(pid, 0)
                    delta = io_now - io_old
                    if delta > 0:
                        try:
                            name = psutil.Process(pid).name()
                        except (psutil.NoSuchProcess, psutil.AccessDenied):
                            name = "N/A"
                        deltas.append((delta, pid, name))
                
                # Sort and report top_n
                deltas.sort(reverse=True, key=lambda x: x[0])
                print(f"\nTop {top_n} processes by I/O in this period:")
                for delta, pid, name in deltas[:top_n]:
                    print(f"PID {pid:<6} Name: {name:<25} I/O: {delta} bytes")
                print("==============================\n")
        
        time.sleep(interval)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Monitor Linux cache and correlate I/O spikes")
    parser.add_argument("--window", type=int, default=10, help="Time window in seconds")
    parser.add_argument("--threshold", type=int, default=100*1024*1024, help="Cache increase threshold in bytes")
    parser.add_argument("--interval", type=int, default=1, help="Sampling interval in seconds")
    parser.add_argument("--top", type=int, default=5, help="Number of top processes to report")
    args = parser.parse_args()

    monitor(args.window, args.threshold, args.interval, args.top)
