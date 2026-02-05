## Quick Commands

```bash
chmod +x get.sh scripts/update_all.sh scripts/run_pipeline_now.sh

# validate
bash -n get.sh scripts/update_all.sh scripts/run_pipeline_now.sh
./get.sh --help

# generate
./get.sh IR all
./get.sh ALL json --save-cache
./get.sh ALL all --save-cache
./get.sh ALL all --from-cache

# local pipeline now
./scripts/run_pipeline_now.sh

# github pipeline now
gh workflow run get.yml
```
