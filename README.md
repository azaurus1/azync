# azync

## Overview
A distributed task queue written in Zig.

Inspired by [asynq](https://github.com/hibiken/asynq) and [Celery](https://github.com/celery/celery)

**azync** aims to provide a fast, minimal, and type-safe task processing system.

## Features (planned)
- Producer/Consumer APIs — simple client for enqueuing tasks, and worker abstraction for consuming them.
- Task Types — strongly typed payloads with encoding/decoding support.
- Queues & Priorities — multiple named queues, with priority handling.
- Retries & Error Handling — configurable retry policy, dead-letter queues.
- Scheduling — delayed tasks, periodic scheduling (cron-like).
- Metrics & Observability — Prometheus metrics, structured logs.
- Cluster Mode — support for scaling workers horizontally with Redis as the broker.

## Inspiration:
- [asynq](https://github.com/hibiken/asynq)
- [Celery](https://github.com/celery/celery)
