### Скрипты для извлечения треков из субтитров видео-файлов регистратора

Проверялось на моделях:
* Datakam 6 max/pro
* Trendvision 718GNS

### Порядок действий

1. Создать файл со списком фрагментов
```bash
find -name '*.MP4' -printf "file '%f'\n" | sort > mylist.txt
```
2. Выгрузить объединенные субтитры из указанных файлов с помощью `ffmpeg`
```bash
ffmpeg -f concat -i mylist.txt -map 0:s:0 -c copy -f data out.data
```
3.  Преобразовать полученный файл в файл гео. данных
```bash
grep -aoE $'\$G[A-Z]+RMC[A-Z\.,*0-9]+\n' out.data > out.nmea
```
4.  Полученные данные преобразовать в gpx с помощью `parse.rb`
```bash
ruby parse.rb
```
