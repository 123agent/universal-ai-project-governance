# Build Commands

> 由 builder agent 在首次接触项目时填写，此后遇到命令变化时随手更新。
> 作用：让每一个接手的 agent 不用重新探索"如何跑测试/如何构建"。
> 人工可以校验和修正，但不需要主动维护——agent 负责保持准确。

---

## How to install dependencies

```
# 例：npm install / pip install -r requirements.txt / bundle install
```

## How to run tests

```
# 例：pytest tests/ -v / npm test / go test ./...
```

## How to run a single test file

```
# 例：pytest tests/auth/test_register.py -v
```

## How to build / compile

```
# 例：npm run build / python -m build / cargo build
# 如无需构建步骤，写 "N/A"
```

## How to start the dev server / local run

```
# 例：npm run dev / python -m uvicorn app.main:app --reload
# 如无，写 "N/A"
```

## How to lint / static check

```
# 例：npm run lint / ruff check . / golangci-lint run
# 如无，写 "N/A"
```

## Environment setup notes

<!-- 首次运行前需要的环境变量、secrets、或特殊配置 -->
<!-- 例："需要 .env 文件，参考 .env.example" -->

## Known gotchas

<!-- 运行命令时容易踩的坑 -->
<!-- 例："pytest 需要从项目根目录运行，不能从 tests/ 目录内运行" -->
<!-- 如无，写 "None" -->
