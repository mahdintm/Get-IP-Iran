## GlobalIP-Device-Lists by Mahdi

بله، از RIPE میشه برای همه کشورها گرفت: به ازای هر کد کشور ISO-2 یک درخواست زده میشه.

این ریپو خروجی IP Prefix (IPv4/IPv6) رو برای همه کشورها جداگانه می‌سازه و پوشه‌بندی تمیز داره.

### ساختار پوشه‌ها

- `output/json/CC.json`
- `output/mikrotik/CC.rsc`
- `output/linux/CC.txt`
- `output/cisco/CC.cfg`
- `output/fortigate/CC.conf`
- `data/cache/CC.json` (برای آپدیت سریع/آفلاین)

### دستگاه‌ها

- `mikrotik`
- `linux`
- `cisco`
- `fortigate`
- `json`
- `all` (همه خروجی‌ها)

### دستورات

```bash
# یک کشور، یک خروجی
./get.sh IR mikrotik

# یک کشور، همه خروجی‌ها
./get.sh IR all

# همه کشورها، فقط json
./get.sh ALL json --save-cache

# همه کشورها، همه خروجی‌ها
./get.sh ALL all --save-cache

# فقط از کش لوکال بخوان
./get.sh ALL all --from-cache
```

### اجرای پایپ‌لاین همین الان

```bash
./scripts/run_pipeline_now.sh
```

### آپدیت اتوماتیک

- اسکریپت آپدیت کامل: `scripts/update_all.sh`
- گیت‌هاب اکشن زمان‌بندی‌شده: `.github/workflows/get.yml` (هر ۶ ساعت + اجرای دستی)

### اسم پیشنهادی برای سرچ گوگل

**GlobalIP-Device-Lists**

### Author

Mahdi
