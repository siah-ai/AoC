import time
start_time = time.time()
Column1 = []
Column2 = []
gap = 0
simscores = 0

with open("./input.txt", 'r') as file:
    for line in file:
        snums = line.split(' ')
        Column1.append(int(snums[0]))
        Column2.append(int(snums[-1]))

Column1.sort()
Column2.sort()

for i in range(len(Column1)):
    if Column1[i] > Column2[i]:
        gap = gap + (Column1[i]-Column2[i])
    else:
        gap = gap + (Column2[i]-Column1[i])

for num in Column1:
    simscores = simscores+(num*Column2.count(num))

print("Part 1:",gap)
print("Part 2:",simscores)
print("Elapsed Time: %s seconds" % round((time.time() - start_time),3))