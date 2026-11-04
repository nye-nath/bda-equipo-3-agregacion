# Solución: Hapax Legomena

Dentro del contenedor:

```bash
cd /opt/hadoop/share/hadoop/mapreduce
/opt/hadoop/bin/hadoop jar hadoop-mapreduce-examples-3.3.6.jar wordcount /tmp/agregacion /tmp/salida_wordcount
awk '$2 == 1' /tmp/salida_wordcount/part-r-00000 | wc -l
```

Resultado: 4147 palabras aparecen una sola vez.

Cómo funciona: `wordcount` manda `(palabra, 1)` en el map y suma en el reduce, así que cada línea de la salida trae una palabra con su total. El `awk` se queda solo con las líneas donde el conteo es 1 y `wc -l` las cuenta.

Nota: `wordcount` separa por espacios, así que "Romeo," y "Romeo" cuentan como palabras distintas.
