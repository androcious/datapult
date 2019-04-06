CRONJOB TEXT:

To get the data pull happening daily...
`$ sudo crontab -e`
in the file enter
```
mm hh * * * python /path/to/repo/scripts/fill.py "today"
mm hh * * * python /path/to/repo/scripts/calc.py
```
