# GlobalIP-Device-Lists by Mahdi

A public project to generate clean country IP prefix lists (IPv4/IPv6) for everyone.

---

## 🇬🇧 English

### What this repo does
- Fetches country prefixes from RIPE (`country-resource-list`) per ISO-2 country.
- Generates separated outputs per country and per platform.
- Supports live fetch + cache fallback for better reliability.

### Output structure
- `output/json/CC.json`
- `output/mikrotik/CC.rsc`
- `output/linux/CC.txt`
- `output/cisco/CC.cfg`
- `output/fortigate/CC.conf`
- `data/cache/CC.json`

### Devices
- `mikrotik`
- `linux`
- `cisco`
- `fortigate`
- `json`
- `all`

### Commands
```bash
chmod +x get.sh scripts/update_all.sh scripts/run_pipeline_now.sh

# single country
./get.sh IR all

# all countries
./get.sh ALL all --save-cache

# cache-only mode
./get.sh ALL all --from-cache

# run local pipeline now (quick demo with cache)
./scripts/run_pipeline_now.sh
```

### Run pipeline now (GitHub)
1. Go to **Actions → Update Country IP Lists → Run workflow**
2. Or with GitHub CLI:
```bash
gh workflow run get.yml
```

---

## 🇮🇷 فارسی

### این ریپو چه کاری انجام می‌دهد؟
- برای هر کشور (ISO-2) از RIPE لیست Prefix می‌گیرد.
- خروجی‌ها را تمیز و جداگانه به ازای هر کشور/دستگاه می‌سازد.
- حالت آنلاین + fallback به کش دارد تا همیشه قابل استفاده باشد.

### ساختار خروجی
- `output/json/CC.json`
- `output/mikrotik/CC.rsc`
- `output/linux/CC.txt`
- `output/cisco/CC.cfg`
- `output/fortigate/CC.conf`
- `data/cache/CC.json`

### دستورها
```bash
./get.sh IR all
./get.sh ALL all --save-cache
./get.sh ALL all --from-cache
./scripts/run_pipeline_now.sh
```

### اجرای پایپ‌لاین همین الان
- از مسیر **Actions → Update Country IP Lists → Run workflow** اجرا کن.
- یا با GitHub CLI:
```bash
gh workflow run get.yml
```

---

## Suggested searchable name
**GlobalIP-Device-Lists**

## Author
Mahdi
