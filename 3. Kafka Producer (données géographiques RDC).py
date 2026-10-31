from kafka import KafkaProducer
import json, time, random

regions = [
    {"name": "Goma", "lat": -1.6788, "lon": 29.2228},
    {"name": "Kinshasa", "lat": -4.4419, "lon": 15.2663},
    {"name": "Bukavu", "lat": -2.4900, "lon": 28.8200},
    {"name": "Lubumbashi", "lat": -11.6647, "lon": 27.4794}
]

producer = KafkaProducer(
    bootstrap_servers='kafka:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

while True:
    r = random.choice(regions)
    
    data = {
        "region": r["name"],
        "lat": r["lat"],
        "lon": r["lon"],
        "cas": random.randint(10, 300),
        "deces": random.randint(0, 20),
        "gueris": random.randint(5, 200)
    }
    
    producer.send("epidemie", data)
    time.sleep(2)
