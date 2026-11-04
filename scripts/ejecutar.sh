#!/bin/bash
# Ejecutar DENTRO del contenedor Hadoop
HADOOP=/opt/hadoop/bin/hadoop
JAR=hadoop-mapreduce-examples-3.3.6.jar

rm -rf /tmp/salida_agg_wc /tmp/salida_agg_hist /tmp/salida_wordcount
cd /opt/hadoop/share/hadoop/mapreduce

echo "=== aggregatewordcount ==="
$HADOOP jar $JAR aggregatewordcount /tmp/agregacion /tmp/salida_agg_wc 1 textinputformat
echo "=== aggregatewordhist ==="
$HADOOP jar $JAR aggregatewordhist /tmp/agregacion /tmp/salida_agg_hist 1 textinputformat
echo "=== wordcount (para el ejercicio de Hapax) ==="
$HADOOP jar $JAR wordcount /tmp/agregacion /tmp/salida_wordcount

echo
echo "=== RESULTADOS ==="
echo "aggregatewordcount:"; cat /tmp/salida_agg_wc/part-r-00000
echo "aggregatewordhist:";  cat /tmp/salida_agg_hist/part-r-00000

head -20 /tmp/salida_wordcount/part-r-00000 > /tmp/muestra_wordcount.txt
N=$(awk '$2 == 1' /tmp/salida_wordcount/part-r-00000 | wc -l)
echo $N > /tmp/hapax.txt
echo "Palabras que aparecen 1 vez: $N"
