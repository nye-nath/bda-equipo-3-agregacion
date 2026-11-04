#!/bin/bash
rm -rf /tmp/salida_agg_wc /tmp/salida_agg_hist
cd /opt/hadoop/share/hadoop/mapreduce
hadoop jar hadoop-mapreduce-examples-3.3.6.jar aggregatewordcount /tmp/agregacion /tmp/salida_agg_wc 1 textinputformat
hadoop jar hadoop-mapreduce-examples-3.3.6.jar aggregatewordhist /tmp/salida_agg_wc /tmp/salida_agg_hist 1 textinputformat
