# Equipo 3: Ejemplos de Agregación en MapReduce

Ejemplos: `aggregatewordcount` y `aggregatewordhist`

- Integrantes: Nathalia, Christopher y Uriel
- Grupo: IDIA 222
- Materia: Manejo Masivo de Datos (ED.01.02)

---

## 1. Qué hacen los ejemplos y para qué sirven

Estos ejemplos usan la librería de agregación de Hadoop. En vez de programar el Reducer a mano, el Mapper manda pares con un tipo de agregación (por ejemplo, sumar) y Hadoop se encarga de combinarlos.

- `aggregatewordcount`: según la documentación, lee un texto, separa cada línea en palabras y cuenta cuántas veces sale cada una.
- `aggregatewordhist`: según la documentación, saca un histograma de las palabras del texto.

Un caso real donde sirve es el análisis de vocabulario en procesamiento de lenguaje natural, por ejemplo para medir qué tan variado es el vocabulario de un corpus grande o para encontrar palabras que aparecen una sola vez.

Con Hadoop 3.3.6 la salida de los dos ejemplos es una sola línea, `record_count`, con el total de líneas del archivo. La explicación está en la sección 6.

---

## 2. Requisitos

- El contenedor de Docker llamado `hadoop`, con Hadoop 3.3.6 (el de la práctica de Hadoop Standalone en contenedor Debian).
- Git instalado en tu computadora.

---

## 3. Guía paso a paso

Cada bloque dice dónde se ejecuta:

- [PC]: en la terminal de tu computadora (el prompt es algo como `usuario@equipo`)
- [CONTENEDOR]: dentro del contenedor (el prompt dice `root@hadoop`)

### Paso 1: clonar el repositorio [PC]
```bash
git clone https://github.com/nye-nath/bda-equipo-3-agregacion.git
cd bda-equipo-3-agregacion
```

### Paso 2: encender el contenedor [PC]
```bash
docker start hadoop
```

### Paso 3: copiar los scripts al contenedor [PC]
```bash
docker cp datos/descargar_datos.sh hadoop:/tmp/
docker cp scripts/ejecutar.sh hadoop:/tmp/
```

### Paso 4: entrar al contenedor [PC]
```bash
docker exec -it hadoop bash
```
El prompt cambia a `root@hadoop:/#`.

### Paso 5: descargar los datos [CONTENEDOR]
```bash
bash /tmp/descargar_datos.sh
```
Esto baja el texto de Romeo y Julieta y lo deja en `/tmp/agregacion/romeo.txt`.

### Paso 6: correr los ejemplos [CONTENEDOR]
```bash
bash /tmp/ejecutar.sh
```
El script corre `aggregatewordcount`, `aggregatewordhist` y `wordcount`. Al final muestra los resultados y cuántas palabras aparecen una sola vez.

### Paso 7: salir y copiar los resultados
Primero salir del contenedor [CONTENEDOR]:
```bash
exit
```
Ya en tu computadora [PC]:
```bash
docker cp hadoop:/tmp/salida_agg_wc/part-r-00000 ./resultados/muestra_wc.txt
docker cp hadoop:/tmp/salida_agg_hist/part-r-00000 ./resultados/muestra_hist.txt
docker cp hadoop:/tmp/muestra_wordcount.txt ./resultados/muestra_wordcount.txt
docker cp hadoop:/tmp/hapax.txt ./resultados/hapax.txt
```

---

## 4. Resultado esperado

Los archivos `resultados/muestra_wc.txt` y `resultados/muestra_hist.txt` tienen esta línea:
```
record_count    4409
```
El archivo `resultados/muestra_wordcount.txt` tiene las primeras 20 líneas del conteo por palabra, en formato `palabra  conteo`.

Con `wordcount` salen 6394 palabras distintas, y 4147 de ellas aparecen una sola vez en el texto.

---

## 5. Cómo funcionan Map y Reduce aquí

![Diagrama de Map y Reduce](diagrama.png)

- Map: recibe una línea del texto y manda un par con su identificador de agregación. En esta corrida leyó 4409 registros (`Map input records=4409`) y mandó 4409 pares.
- Combine: suma de forma local antes de mandar los datos al reducer. Entraron 4409 registros y salió 1 (`Combine output records=1`), así viaja menos información.
- Reduce: recibe ese único grupo ya sumado y escribe el resultado final, `record_count 4409`.

En el `wordcount` normal el map manda `(palabra, 1)` por cada palabra y el reduce suma los unos de cada una.

---

## 6. Problemas que aparecieron

**Los ejemplos de agregación dan `record_count` en lugar de palabras.**
La salida es una sola línea con 4409. Se revisó con `wc -l /tmp/agregacion/romeo.txt`, que da 4408. La diferencia de uno se debe a que la última línea del archivo no termina en salto de línea (con `grep -c '' /tmp/agregacion/romeo.txt` sale 4409). Coincide con un problema reportado en Apache Hadoop, [MAPREDUCE-7376](https://issues.apache.org/jira/browse/MAPREDUCE-7376), donde `AggregateWordCount` da el número de filas en vez de contar palabras. Para el ejercicio se usa `wordcount`, que sí cuenta por palabra.

**`container is not running`**
Se arregla con `docker start hadoop` en la terminal de tu computadora.

**`hadoop: command not found`**
Hay que usar la ruta completa, `/opt/hadoop/bin/hadoop`. Ya viene así en `ejecutar.sh`.

**Los comandos de `docker` no funcionan**
Los comandos de `docker` se escriben en la terminal de tu computadora, no donde el prompt dice `root@hadoop`.

---

## 7. Mini ejercicio

Está en la carpeta `ejercicio/`: el enunciado en `ejercicio.md` y la solución en `solucion.md`.
