## Get IP Iran

This script is for get iran ip subnet and added to address list mikrotik

## How to use script

```bash
foreach i in={"Iran"} do={
  /tool fetch url="https://raw.githubusercontent.com/MrAriaNet/Get-IP-Iran/main/list.rsc" dst-path=Iran
  /import file-name=$i
  /file remove $i
}
```

## Author

[Mahdi](https://github.com/mahdintm)
