# FILL-IN: Open Questions for the Team

Every blank in this documentation set is written as a double-bracket marker
that starts with `FILL:` and contains a short description. This file lists each
marker once, in document order. Answer the question, then replace the marker in
the named file and mark the row as done.

## How to fill a blank

1. In VS Code, press `Ctrl+Shift+F` (search in files) and search for `[[FILL:`.
   Restrict "files to include" to the documentation folder if needed.
2. Pick a row below, run the command in the "Command" column if one is given,
   and write the result in the **Answer** column.
3. Open the file named in "File and section", find the marker with the same
   description, and replace the **whole marker, including both pairs of
   brackets**, with the answer.
4. If the blank sits in a "Confidence" column labelled **Blank**, change that
   label as well (usually to "Verified on the cluster, <date>").
5. Set **Status** to `done` (or `n/a` with a reason if the question no longer
   applies). Leave rows in place so the IDs stay stable.

## Open questions

| ID | Question for the team | File and section | Command to get the answer (if any) | Answer | Status |
|---|---|---|---|---|---|
| F-001 | Documentation owner name and role? | [README.md](README.md) | - |  |  |
| F-002 | Date of last team review of these docs? | [README.md](README.md) | - |  |  |
| F-003 | Project checkout path on the master VM? | [README.md](README.md#4-quick-start) > 4. Quick start | `pwd` (inside the checkout on the master) |  |  |
| F-004 | Where the base BGE-M3 model files in .models/bge-m3 come from? | [README.md](README.md#4-quick-start) > 4. Quick start | `ls -la .models/bge-m3` |  |  |
| F-005 | Intended end users of the question-answering output? | [01-system-overview.md](01-system-overview.md#1-purpose-and-scope) > 1. Purpose and scope | - |  |  |
| F-006 | Project context and sponsor (for example course, research group, company)? | [01-system-overview.md](01-system-overview.md#1-purpose-and-scope) > 1. Purpose and scope | - |  |  |
| F-007 | Target number of articles or months to ingest for the project? | [01-system-overview.md](01-system-overview.md#1-purpose-and-scope) > 1. Purpose and scope | - |  |  |
| F-008 | Machine that runs scripts/ask.py? | [01-system-overview.md](01-system-overview.md#2-system-context) > 2. System context | - |  |  |
| F-009 | Groq account tier and rate limits (requests per minute, tokens per minute, tokens per day)? | [01-system-overview.md](01-system-overview.md#7-external-dependencies) > 7. External dependencies | - |  |  |
| F-010 | Whether a Gemini API key exists and which account it belongs to? | [01-system-overview.md](01-system-overview.md#7-external-dependencies) > 7. External dependencies | - |  |  |
| F-011 | Current row counts of pages, article_chunks, chunk_analyses and chunk_embeddings in the live database? | [01-system-overview.md](01-system-overview.md#8-current-data-snapshot) > 8. Current data snapshot | `./scripts/inspect_db.sh`; `psql -c "SELECT count(*) FROM chunk_embeddings;"` |  |  |
| F-012 | Location and contents of cluster_up.sh and cluster_down.sh? | [01-system-overview.md](01-system-overview.md#9-what-is-outside-the-repository) > 9. What is outside the repository | `ls -l ~/cluster_up.sh ~/cluster_down.sh` (on the Debian host) |  |  |
| F-013 | Location of clean_results.py and whether it is still used? | [01-system-overview.md](01-system-overview.md#9-what-is-outside-the-repository) > 9. What is outside the repository | `find / -name clean_results.py 2>/dev/null` |  |  |
| F-014 | Which machine runs PostgreSQL? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#1-topology) > 1. Topology | `psql -c "SELECT inet_server_addr(), inet_server_port();"` |  |  |
| F-015 | Physical host hostname? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `hostname -f` |  |  |
| F-016 | Physical host hardware model? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `sudo dmidecode -s system-product-name` |  |  |
| F-017 | Physical host CPU model and core/thread count? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `lscpu` |  |  |
| F-018 | Physical host total RAM? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `free -h` |  |  |
| F-019 | Physical host disk type and size? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `lsblk -d -o NAME,SIZE,ROTA,MODEL` |  |  |
| F-020 | Debian version on the physical host? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `cat /etc/os-release` |  |  |
| F-021 | VMware product and version (Workstation, Player or ESXi)? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | `vmware --version` (Workstation) or `vmware -v` (ESXi) |  |  |
| F-022 | host-side path of the copy_path shared folder? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#2-physical-host) > 2. Physical host | VMware: VM Settings > Options > Shared Folders |  |  |
| F-023 | Master VM vCPU count? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `nproc` (on that VM) |  |  |
| F-024 | Master VM RAM? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `free -h` |  |  |
| F-025 | Master VM disk size? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `lsblk -d -o NAME,SIZE,ROTA,MODEL` |  |  |
| F-026 | Master VM operating system and version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `cat /etc/os-release` |  |  |
| F-027 | Master VM IP address? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `ip -br addr` |  |  |
| F-028 | worker1 vCPU count? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `nproc` (on that VM) |  |  |
| F-029 | worker1 disk size? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `lsblk -d -o NAME,SIZE,ROTA,MODEL` |  |  |
| F-030 | worker1 operating system and version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `cat /etc/os-release` |  |  |
| F-031 | worker1 IP address? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `ip -br addr` |  |  |
| F-032 | worker2 vCPU count? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `nproc` (on that VM) |  |  |
| F-033 | worker2 disk size? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `lsblk -d -o NAME,SIZE,ROTA,MODEL` |  |  |
| F-034 | worker2 operating system and version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `cat /etc/os-release` |  |  |
| F-035 | worker2 IP address? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `ip -br addr` |  |  |
| F-036 | worker3 vCPU count? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `nproc` (on that VM) |  |  |
| F-037 | worker3 disk size? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `lsblk -d -o NAME,SIZE,ROTA,MODEL` |  |  |
| F-038 | worker3 operating system and version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `cat /etc/os-release` |  |  |
| F-039 | worker3 IP address? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `ip -br addr` |  |  |
| F-040 | Machine that runs scripts/ask.py and its RAM? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#3-virtual-machines) > 3. Virtual machines | `free -h` |  |  |
| F-041 | Java version on the cluster? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `java -version` |  |  |
| F-042 | Hadoop version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `hadoop version` |  |  |
| F-043 | Spark version installed under SPARK_HOME on the cluster? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `$SPARK_HOME/bin/spark-submit --version` |  |  |
| F-044 | Python version used for .venv and on the workers? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `.venv/bin/python --version`; `ssh worker1 python3 --version` |  |  |
| F-045 | PostgreSQL server version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `psql -c "SELECT version();"` |  |  |
| F-046 | pgvector extension version? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#41-system-software) > 4.1 System software | `psql -c "SELECT extversion FROM pg_extension WHERE extname='vector';"` |  |  |
| F-047 | Output of pip freeze for .venv, .venv-embedding-onnx and .venv-rag? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#42-python-packages-pinned-or-ranged-in-requirements) > 4.2 Python packages (pinned or ranged in `requirements/`) | `.venv/bin/python -m pip freeze` (repeat for `.venv-embedding-onnx`, `.venv-rag`) |  |  |
| F-048 | HDFS NameNode RPC port? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#5-network) > 5. Network | `hdfs getconf -confKey fs.defaultFS` |  |  |
| F-049 | Spark driver port range or firewall rule between workers and master? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#5-network) > 5. Network | `grep -E 'spark\.(driver\|blockManager)\.port' $SPARK_HOME/conf/spark-defaults.conf` |  |  |
| F-050 | VM network mode (NAT, bridged or host-only) and subnet? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#5-network) > 5. Network | VMware VM network settings; `ip route` inside a VM |  |  |
| F-051 | Whether outbound traffic from the VMs goes through a proxy? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#5-network) > 5. Network | `env \| grep -i proxy` |  |  |
| F-052 | Current size of the warcdb database? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#61-where-data-lives) > 6.1 Where data lives | `psql -c "SELECT pg_size_pretty(pg_database_size('warcdb'));"` |  |  |
| F-053 | PostgreSQL data directory path and its disk? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#61-where-data-lives) > 6.1 Where data lives | `psql -c "SHOW data_directory;"` then `df -h <path>` |  |  |
| F-054 | Size of .models/bge-m3? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#61-where-data-lives) > 6.1 Where data lives | `du -sh .models/bge-m3` |  |  |
| F-055 | Spark event log directory and retention? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#61-where-data-lives) > 6.1 Where data lives | `grep -i eventLog $SPARK_HOME/conf/spark-defaults.conf` |  |  |
| F-056 | OS user that runs the pipeline on the master? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#7-accounts-and-access) > 7. Accounts and access | `whoami` (in the shell that runs the launchers) |  |  |
| F-057 | How team members access the VMs (SSH users, keys, jump host)? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#7-accounts-and-access) > 7. Accounts and access | - |  |  |
| F-058 | Target production hardware or hosting decision? | [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md#8-production-hardware) > 8. Production hardware | - |  |  |
| F-059 | yarn.scheduler.minimum-allocation-mb and yarn.nodemanager.resource.memory-mb on the workers? | [03-cluster-design.md](03-cluster-design.md#3-resource-sizing-per-stage) > 3. Resource sizing per stage | `grep -A1 -E 'minimum-allocation-mb\|resource.memory-mb' $HADOOP_HOME/etc/hadoop/yarn-site.xml` |  |  |
| F-060 | Number of executors YARN actually grants for chunking and tagging at default settings? | [03-cluster-design.md](03-cluster-design.md#3-resource-sizing-per-stage) > 3. Resource sizing per stage | Spark UI > Executors tab during `./scripts/run_chunking.sh --document-limit 10` |  |  |
| F-061 | Contents of spark-defaults.conf on the master? | [03-cluster-design.md](03-cluster-design.md#4-spark-settings-applied-by-the-code) > 4. Spark settings applied by the code | `cat $SPARK_HOME/conf/spark-defaults.conf` |  |  |
| F-062 | Whether the team runs several stages at the same time on the cluster? | [03-cluster-design.md](03-cluster-design.md#7-coordination-between-jobs) > 7. Coordination between jobs | - |  |  |
| F-063 | dfs.replication value? | [03-cluster-design.md](03-cluster-design.md#9-cluster-services-configuration) > 9. Cluster services configuration | `hdfs getconf -confKey dfs.replication` |  |  |
| F-064 | Which VMs run the NameNode and the DataNodes? | [03-cluster-design.md](03-cluster-design.md#9-cluster-services-configuration) > 9. Cluster services configuration | `hdfs dfsadmin -report` |  |  |
| F-065 | Whether yarn.log-aggregation-enable is on and where logs are kept? | [03-cluster-design.md](03-cluster-design.md#9-cluster-services-configuration) > 9. Cluster services configuration | `grep -A1 log-aggregation $HADOOP_HOME/etc/hadoop/yarn-site.xml` |  |  |

## Count check

Markers found in the documentation files (README.md, 01-11 and 04-modules/,
not counting the search text in step 1 of this file): **65**.
Rows in the table above: **65**. The table is generated from the
markers, so both numbers are equal by construction; they are re-checked after
every batch.
