from kafka import KafkaConsumer
import json
import psycopg2

consumer = KafkaConsumer(
    'epidemie',
    bootstrap_servers='kafka:9092',
    value_deserializer=lambda x: json.loads(x.decode('utf-8'))
)

conn = psycopg2.connect(
    dbname="epidemiologie",
    user="postgres",
    password="password",
    host="postgres"
)

cur = conn.cursor()

for msg in consumer:
    d = msg.value
    
    cur.execute("""
        INSERT INTO cas_epidemio(date, region, lat, lon, cas, deces, gueris, geom)
        VALUES (
            NOW(), %s, %s, %s, %s, %s, %s,
            ST_SetSRID(ST_MakePoint(%s, %s), 4326)
        )
    """, (
        d["region"], d["lat"], d["lon"],
        d["cas"], d["deces"], d["gueris"],
        d["lon"], d["lat"]
    ))
    
    conn.commit()
    print("Inserted:", d)
