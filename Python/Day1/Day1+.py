import itertools

freq = 0
seen = {0}
numbers = [int(line) for line in iter(input, '')]
for num in itertools.cycle(numbers):
    freq += num
    if freq in seen:
        print(freq)
        break
    seen.add(freq)