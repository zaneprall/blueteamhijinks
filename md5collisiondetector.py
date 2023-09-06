import hashlib
import random
import string

def md5(data):
    m = hashlib.md5()
    m.update(data.encode('utf-8'))
    return m.hexdigest()

hashes1 = {}
hashes2 = {}

# Generate first set of random strings and their hashes
for _ in range(100000):  # This number is just for example; you'd use a much larger number.
    data = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    h = md5(data)
    hashes1[h] = data

# Generate second set of random strings and their hashes, checking for collision
for _ in range(100000):  # Again, the number is for example only.
    data = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    h = md5(data)
    if h in hashes1:
        print(f"Collision found: {data} and {hashes1[h]} have the same hash {h}")
        break
    hashes2[h] = data
