#Plugins we are using
import shutil, glob, os, csv, sys

file = sys.argv[1]
species = file.split(".")[0]

#Open collinearity file
f1 = open(f"{species}.final", 'r' ).read()
f1 = f1.split("## Alignment")[1:]
chromes = []
for i in f1:
    i = i.split("\n")
    chromes.extend(i[0].split(" ")[-2].split("&"))


#Open fasta file
f1 = open(f"{file}", 'r' ).read()
f1 = f1.split("\n")

data = {}

for line in f1:
    line = line.split("\t")
    if len(line) >= 2:
         if f"{line[0]}" in data:
              data[line[0]].append(line[1])

         else:
              data[line[0]] = [line[1]]

final = []
for key, value in data.items():
    final.append([key,len(value)])

# plot = []
# for i in final:
#     if i[0] in chromes:
#         plot.append(i)


final.sort(key = lambda row: row[1])

final = final[::-1]

string = []
for i in final[0:20]:
   string.append(i[0])

print("800")
print("800")
print(",".join(string))
print(",".join(string))



