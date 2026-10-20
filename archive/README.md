# Detailed Legacy References

These are the team's original design documents from `sparc_baseline/docs/`,
copied **unchanged** except that links pointing outside the `docs/` folder
(for example `../README.md` or `../ingestion/pipeline.py`) now point to
`../../sparc_baseline/...` so they still resolve. Line endings are preserved.

They are kept as detailed references. Where they disagree with the code, the
code at commit `2f319be` and the main documentation set win.

| File | Contents | Main-doc chapter that supersedes it |
|---|---|---|
| [architecture.md](architecture.md) | Ingestion architecture, quotas, transactions, memory bounds, module graph | [01](../01-system-overview.md), [03](../03-cluster-design.md), [04-modules/](../04-modules/) |
| [module_map.md](module_map.md) | Public signatures and import relationships per module | [04-modules/](../04-modules/) |
| [processing.md](processing.md) | Chunking, tagging and embedding jobs: configuration, batching, recovery | [04-modules/](../04-modules/), [07](../07-configuration.md) |
| [workflows.md](workflows.md) | Mermaid workflow and state diagrams for every stage | [05](../05-data-flow.md) |
| [retrieval-chatbot-design.md](retrieval-chatbot-design.md) | Retrieval and chatbot design decisions | [04-modules/retrieval.md](../04-modules/retrieval.md) |
| [rag-api-plan.md](rag-api-plan.md) | Plan for evaluation and a FastAPI service | [10](../10-prototype-vs-production.md), [11](../11-roadmap-and-known-issues.md) |
| [validation.md](validation.md) | Recorded local and YARN validation results (2026-09-30 / 2026-10-01) | [09](../09-operations.md) |

## Verification against the code

Each legacy document was checked against the baseline code. The statements
below do **not** match the code. They are left as they are in the copies.

| # | Document and line | Legacy statement | What the code does |
|---|---|---|---|
| L1 | `module_map.md:124-127` | Ingestion result candidates contain `raw_html`, `source`, `clean_text`, `page_url`. | Candidates contain `record_id`, `url`, `file_url`, `warc_date`, `title`, `author`, `published_date`, `cleaned_text`, `word_count`, `char_count`, `links_count`, `headings`, `language`, `arabic_dialect`, `extraction` (`ingestion/pipeline.py:189-207`). |
| L2 | `module_map.md:167` | `identity(config)` returns `(chunking_version, backend, model)`. | Returns four values, including `analysis_version` (`db/analyses.py:10-11`). |
| L3 | `module_map.md:161, 164` | `acquire_lock(stage)` returns a context manager; `counts` returns `eligible`, `materialized`, `pending`. | `acquire_lock` returns a plain connection holding the lock; `counts` returns `documents`, `stored`, `filtered` (`db/chunks.py:13-25, 72-79`). |
| L4 | `module_map.md:232` | Chunking task dict has `documents`, `items_per_task`, `result_bytes`, `max_length`. | Task dict is `{"items", "result_bytes"}` (`chunking/pipeline.py:44-45`). |
| L5 | `module_map.md:333` | Embedding task dict has `rows`. | Task dict is `{"items", "max_length", "result_bytes"}` (`embeddings/pipeline.py:42-43`). |
| L6 | `module_map.md:431` | `read_counts(...)` returns a dict. | Returns a tuple `(eligible, embedded)` (`scripts/watch_embeddings.py:14-31`). |
| L7 | `architecture.md:213` | The `--py-files` archive contains `ingestion/`, `db/`, `chunking/`, `tagging/`, `jobs/`. | It also contains `embeddings/` (`scripts/run_processing.sh:49`). |
| L8 | `architecture.md:245`; `sparc_baseline/README.md:32` | "Create `retrieval/` when ... code is added." | `retrieval/` exists and is the RAG layer. |
| L9 | `retrieval-chatbot-design.md:92` | Corpus candidate ranking uses pgvector inner-product similarity. | Search orders by cosine distance `<=>` (`retrieval/store.py:67, 80`); the inner-product HNSW index is not used. |
| L10 | `retrieval-chatbot-design.md:109-110` | Reranking models are deferred. | A BGE cross-encoder reranker is implemented and mandatory (`retrieval/reranker.py`, `retrieval/store.py:96`); the same document says so at lines 207-210. |
| L11 | `processing.md:41-42` | A migration labels preexisting vectors `legacy-v0`. | `UPGRADE_V5` is defined (`db/vector_schema.py:27-32`) but `init_db` never executes it (`db/db_handler.py:175` only runs a `SELECT`). |
| L12 | `workflows.md:105` | The commit transaction starts by expunging previous wave state. | No such step; `commit_chunk` checks the receipt, locks rows and inserts (`db/db_handler.py:338-405`). |
| L13 | `workflows.md:280-284` | `run_ingestion.sh` is called by `jobs/environment.py`; dry run prints a "resolution table". | `run_processing.sh` re-executes itself through `jobs/environment.py`; dry run runs the stage module, which prints the configuration as JSON (`scripts/run_processing.sh:5-13, 41-43`). |
| L14 | `workflows.md:331` | `quota_reached` files return to `pending` on resume. | `resume_run` resets only `failed` files (`db/db_handler.py:331-335`); a quota-capped file becomes available again only in a new run (`db/db_handler.py:219-223`). |
| L15 | `validation.md:83-84, 103` | Runs use `./run_to_db.sh`. | No such script; the launcher is `scripts/run_ingestion.sh`. |
| L16 | `rag-api-plan.md:45` | Evidence is sent to "Qwen". | The RAG agent uses `openai/gpt-oss-120b` on Groq or `gemini-3.5-flash-lite` (`retrieval/llm.py:15-20`). Qwen is the tagging default (`jobs/runtime.py:80`). |
| L17 | `rag-api-plan.md:111` | API dependencies will go into a new `requirements/rag-api.txt`. | Not created; FastAPI and Uvicorn currently sit in `requirements/embeddings.txt:4-7`. |
