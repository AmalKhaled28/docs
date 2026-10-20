# SPARC News RAG Pipeline: System Documentation

This documentation set describes the News RAG pipeline as one connected system,
from the virtual machines it runs on to the question-answering command at the
end of the chain. It is a **baseline**: every statement traces back to the
project code at commit `2f319be` (folder `sparc_baseline/`), and every fact the
code cannot provide is a marked blank for the team to fill in.

| Item | Value |
|---|---|
| Code baseline | `sparc_baseline/` at commit `2f319beae0e6a2bdf3e84f29f0a6d3bb683abec0` (2026-10-19, message "charts") |
| Documentation owner | [[FILL: documentation owner name and role]] |
| Last reviewed with the team | [[FILL: date of last team review of these docs]] |

## 1. What the system does

The pipeline turns the public **Common Crawl News (CC-NEWS)** web archive into a
searchable, multilingual (Arabic, English, French) news knowledge base, then
answers questions about it with citations.

1. **Ingestion** streams monthly CC-NEWS WARC files over HTTPS, extracts article
   text and metadata on Spark executors, keeps only Arabic, English and French
   articles, and commits them to PostgreSQL from the Spark driver.
   *Verified in code: `ingestion/pipeline.py`, `ingestion/extraction.py`, `db/db_handler.py`.*
2. **Chunking** cleans each stored article and splits it into overlapping
   800-character chunks, marking noisy chunks as ineligible.
   *Verified in code: `chunking/pipeline.py`, `chunking/splitters.py:9-18`.*
3. **Tagging** sends eligible chunks to a large language model (Groq by default)
   for a summary, a topic category and keyword tags.
   *Verified in code: `tagging/pipeline.py`, `tagging/backends/groq.py`.*
4. **Embedding** turns eligible chunks into 1024-dimensional BGE-M3 vectors with
   a local INT8 ONNX model and stores them with pgvector.
   *Verified in code: `embeddings/embeddings.py`, `db/vector_schema.py:13`.*
5. **Retrieval and answering** plans up to three search queries with an LLM,
   runs exact cosine search in PostgreSQL, reranks the candidates with a local
   cross-encoder, and writes a grounded, cited answer.
   *Verified in code: `retrieval/agent.py`, `retrieval/store.py`, `retrieval/reranker.py`.*

Every stage runs as a **manually started, bounded command** today. A
continuously running service is a proposal only (see
[10-prototype-vs-production.md](10-prototype-vs-production.md)).

## 2. Goals of this documentation

- Describe the whole system, including hardware, cluster, modules, data and
  operations, in one place and in one consistent vocabulary.
- Make every statement traceable: code facts cite a file path (and line where
  useful); everything else carries a confidence label.
- Turn missing knowledge into explicit, trackable blanks (&#91;&#91;FILL: ...]]),
  collected in [FILL-IN.md](FILL-IN.md).
- Separate what runs today (**Prototype mode**) from what is proposed
  (**Production mode, Proposed (not implemented)**).
- Record defects without fixing them ([11-roadmap-and-known-issues.md](11-roadmap-and-known-issues.md)).

## 3. Confidence legend

Every factual statement carries one of these labels. In tables the label sits
in a "Confidence" or "Source" column; in prose it follows the statement.

| Label | Meaning | Example |
|---|---|---|
| **Verified in code** (`path:line`) | Read directly from a file in the baseline: source, scripts, requirements, `.env.example`, tests, the original `README.md` or the CSV snapshots in `exports/`. | Executors get one core each. *Verified in code: `scripts/run_processing.sh:145`.* |
| **Inferred** | Follows from code or from the legacy docs but is not stated by code. The reasoning is given. | PostgreSQL probably runs on the master VM (default `PGHOST=localhost`, driver in client mode). |
| **Recommended, not measured** | Our recommendation. No benchmark or measurement in the repository supports a specific value. | Keep at least 50 GB free for PostgreSQL. |
| **Proposed (not implemented)** | A design direction that does not exist in the code. Production mode is always in this category. | A FastAPI service in `query_service/`. |
| &#91;&#91;FILL: ...]] (shown as **Blank** in confidence columns) | Unknown. The code cannot answer it; the team must. Every blank has a row in [FILL-IN.md](FILL-IN.md). | &#91;&#91;FILL: master VM vCPU count]] |

Facts taken only from the legacy team documents are labelled **Inferred
(legacy doc)** with the archive file name, because those documents were written
by hand and some of their statements no longer match the code (see
[archive/README.md](archive/README.md)).

## 4. Quick start

This is the shortest path from a prepared cluster to an answered question.
Preparing the cluster itself (VMs, Hadoop, Spark, PostgreSQL, pgvector) is
covered step by step in [08-deployment-and-running.md](08-deployment-and-running.md).
All commands run from the project root on the Spark master
([[FILL: project checkout path on the master VM]]).

```bash
# 1. Base environment used by every launcher (ingestion, chunking, tagging)
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements/tagging-groq.txt   # includes base + rag
export SPARK_HOME=/opt/spark            # path used in the README; confirm for your cluster
export PATH="$SPARK_HOME/bin:$PATH"

# 2. Configuration: copy the example and fill in credentials
cp .env.example .env                     # then set PGPASSWORD, GROQ_API_KEY, ...

# 3. Validate settings without Spark, PostgreSQL or packaging
./scripts/run_ingestion.sh --dry-run --max-accepted-articles 10

# 4. Smoke ingestion: 1 file, 10 new articles
./scripts/run_ingestion.sh --num-files 1 --max-accepted-articles 10 --max-accepted-per-file 10

# 5. Post-ingestion stages (each can be rerun to resume)
./scripts/run_chunking.sh --document-limit 100
./scripts/run_tagging.sh --analysis-limit 30
bash scripts/setup_embedding_onnx_env.sh
bash scripts/download_quantized_embedding_model.sh   # needs base BGE-M3 files in .models/bge-m3
./scripts/run_embeddings.sh --embedding-limit 100

# 6. Ask a question (separate local environment, not Spark)
python3 -m venv .venv-rag
.venv-rag/bin/python -m pip install -r requirements/rag-agent.txt
bash scripts/download_quantized_reranker_model.sh
.venv-rag/bin/python scripts/ask.py "What happened, and why did it matter?"

# 7. Inspect and export
./scripts/inspect_db.sh
./scripts/export_csv.sh
```

*Verified in code:* commands and paths come from `sparc_baseline/README.md:54-59,
100-120, 194-195, 230-235, 274`, `scripts/run_processing.sh`, the download
scripts, and `archive/processing.md` (verified against `jobs/runtime.py`).
The base BGE-M3 tokenizer files expected in `.models/bge-m3` are not
downloaded by any script (`scripts/download_quantized_embedding_model.sh:20-26`
only checks that they exist): [[FILL: where the base BGE-M3 model files in .models/bge-m3 come from]].

## 5. Documentation map

| File | Contents |
|---|---|
| [01-system-overview.md](01-system-overview.md) | The system as a whole: components, stages, boundaries, design principles |
| [02-hardware-and-infrastructure.md](02-hardware-and-infrastructure.md) | Physical host, VMs, operating systems, software versions, network, storage |
| [03-cluster-design.md](03-cluster-design.md) | Spark on YARN layout, resource sizing, packaging, job submission |
| [04-modules/](04-modules/) | One file per module: ingestion, chunking, tagging, embeddings, retrieval, db, jobs, scripts, query_service |
| [05-data-flow.md](05-data-flow.md) | How data moves and changes shape from WARC record to cited answer |
| [06-database.md](06-database.md) | Every table, key and index, with an ER diagram |
| [07-configuration.md](07-configuration.md) | Every environment variable, flag and config file, with defaults and precedence |
| [08-deployment-and-running.md](08-deployment-and-running.md) | From bare hardware to a running system, step by step |
| [09-operations.md](09-operations.md) | Monitoring, logs, troubleshooting, backup and recovery |
| [10-prototype-vs-production.md](10-prototype-vs-production.md) | What runs today versus the proposed production mode |
| [11-roadmap-and-known-issues.md](11-roadmap-and-known-issues.md) | Roadmap and the Known Issues table |
| [FILL-IN.md](FILL-IN.md) | Every &#91;&#91;FILL: ...]] blank, with the question, location and command to answer it |
| [archive/](archive/) | Detailed legacy references: the team's original documents, unchanged except for links |
| [docs/diagrams/](docs/diagrams/) | Mermaid sources (`src/*.mmd`), rendered SVGs and `build.sh` |

Diagrams are rendered with `bash docs/diagrams/build.sh` (mermaid-cli 10.9.1,
white background). The Markdown files show only the rendered images; edit the
`.mmd` source and rebuild to change a diagram.

## 6. Glossary

| Term | Meaning in this project |
|---|---|
| **CC-NEWS** | Common Crawl's news crawl. Published as monthly lists of WARC files (`warc.paths.gz`) under `https://data.commoncrawl.org/crawl-data/CC-NEWS/YYYY/MM/`. *Verified in code: `ingestion/pipeline.py:161-163`.* |
| **Manifest** | The monthly `warc.paths.gz` file list. Identified internally as `manifest_id = "YYYY/MM"`. *Verified in code: `ingestion/pipeline.py:111`.* |
| **WARC record** | One archived HTTP response inside a WARC file. Only `response` records with an HTML content type are processed. *Verified in code: `ingestion/warc.py:65-73`.* |
| **Run** | One ingestion request with a fixed article target and per-file cap, stored in `ingest_runs` and resumable by `run_id`. *Verified in code: `db/db_handler.py:109-117`.* |
| **Wave** | One round of concurrently executed Spark tasks. Ingestion waves are allocated per file; processing waves contain at most `parallel_tasks` jobs. *Verified in code: `ingestion/pipeline.py:536-589`, `jobs/batching.py:38-77`.* |
| **Ingestion chunk** | One ingestion task result: candidate articles, the next byte offset and statistics, committed atomically and receipted in `ingest_chunks`. Not the same as a text chunk. *Verified in code: `db/db_handler.py:338-405`.* |
| **Text chunk** | A piece of an article (up to 800 characters, 100 overlap) stored in `article_chunks`. *Verified in code: `chunking/splitters.py:9-18`.* |
| **Candidate** | An article that passed worker-side extraction and language filters but is not yet committed. *Verified in code: `ingestion/pipeline.py:189-207`.* |
| **Checkpoint / cursor** | The compressed byte offset of the next unprocessed WARC record of a file (`next_offset`, `bytes_done`). *Verified in code: `db/db_handler.py:103-108, 118-127`.* |
| **Eligible chunk** | A text chunk that passed the noise filters (`eligible = true`, `filter_reason IS NULL`). Only eligible chunks are tagged, embedded and retrieved. *Verified in code: `db/enrichment_schema.py:18-23`.* |
| **`chunking_version`** | Version label of the cleaning, splitting and eligibility rules; part of every chunk key. Current value `recursive-800-100-clean-v2.4.1-v1`. *Verified in code: `chunking/__init__.py:3`.* |
| **`embedding_version`** | Fingerprint of the embedding model files and `max_length` (`bge-m3-int8-<20 hex>`). *Verified in code: `embeddings/embeddings.py:22-35`.* |
| **`analysis_version`** | Version label of the tagging prompt and rules; default `chunk-analysis-v2.4.1`. *Verified in code: `jobs/runtime.py:81`.* |
| **Advisory lock** | A PostgreSQL session lock that allows only one coordinator per stage at a time. *Verified in code: `db/db_handler.py:192-203`, `db/chunks.py:13-25`.* |
| **Driver / executor** | Spark roles. The driver (on the machine that runs the launcher) owns every database read and write; executors only transform data. *Verified in code: `chunking/pipeline.py:10-46`, `ingestion/pipeline.py:353-354` ("no external writes").* |
| **SUCCESS / NOISE / ERROR** | Tagging outcomes per chunk. *Verified in code: `db/enrichment_schema.py:34`.* |
| **Reranker** | Local BGE cross-encoder (`bge-reranker-v2-m3`, INT8 ONNX) that rescores retrieved candidates. *Verified in code: `retrieval/reranker.py`.* |
| **Evidence** | Deduplicated, merged retrieved chunks with scores and sources, passed to the answering LLM. *Verified in code: `retrieval/evidence.py:27-99`.* |
| **Chunk ID** | Citation key `p<page_id>:c<chunk_index>`, for example `p12:c3`. *Verified in code: `retrieval/store.py:60-62`.* |
| **Prototype mode** | How a module runs today: a manual, bounded command. |
| **Production mode** | A continuously running service. Always **Proposed (not implemented)**. |
